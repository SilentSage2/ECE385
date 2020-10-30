---------------------------------------------------------------------------
--      Sound.vhd                                                        --
--      Matthew Grawe & Larry Resnik                                     --
--      Spring 2014 ECE 385 Final Project                                --
--                                                                       -- 
--                                                                       --
--      The sound entity handles both the music and sound effects.       --
--      We make use of audio_interface.vhd, which was originally         --
--      coded by Koushik Roy and released on April 23, 2010.             --
---------------------------------------------------------------------------


LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

entity SOUND is
Port(
        -- RAM Signals
        CE, UB, LB, OE, WE :  out std_logic;
        ADDR               :  out std_logic_vector(17 downto 0);
        RAM_DATA           :  in  std_logic_vector(15 downto 0);
        --SWITCHES         :  in  std_logic_vector(17 downto 0); -- We originally used this for debugging.
        
--        -- Play sound signals: when these go high, the entity will play the respective sound effect.
        EXPLOSION_SOUND    :  in  std_logic;
        BOMB_PLACE_SOUND   :  in  std_logic;
        DEATH_SOUND        :  in  std_logic;
        
        -- CLK, Reset signals
        CLK                :  in  std_logic;
        Reset              :  in  std_logic;
        
        -- audio_interface signals
        AUD_MCLK           :  out std_logic;
        AUD_BCLK           :  in  std_logic;
        AUD_ADCDAT         :  in  std_logic;
        AUD_DACDAT         :  out std_logic;
        AUD_DACLRCK        :  in  std_logic;
        AUD_ADCLRCK        :  in  std_logic;
        I2C_SDAT           :  out std_logic;
        I2C_SCLK           :  out std_logic;
        
        -- other debugging signals
        SW0                :  in  std_logic
        --LEDS             :  out std_logic_vector(17 downto 0)
    );
end SOUND;

architecture Behavioral of SOUND is

-- audio_interface is the entity we used to directly interact with the Altera board audio codec. (Designed by Koushik Roy)
component audio_interface is
	Port
	(	
		LDATA, RDATA	         : in  std_logic_vector(15 downto 0); -- parallel external data inputs
		clk, Reset, INIT         : in  std_logic; 
		INIT_FINISH              : out std_logic;
		adc_full                 : out std_logic; -- will not use this (This is for READING audio, not SENDING audio)
		data_over                : out std_logic; -- sample sync pulse
		AUD_MCLK                 : out std_logic; -- Codec master clock OUTPUT
		AUD_BCLK                 : in  std_logic; -- Digital Audio bit clock
		AUD_ADCDAT               : in  std_logic;
		AUD_DACDAT               : out std_logic; -- DAC data line
		AUD_DACLRCK, AUD_ADCLRCK : in  std_logic; -- DAC data left/right select
		I2C_SDAT                 : out std_logic; -- serial interface data line
		I2C_SCLK                 : out std_logic; -- serial interface clock
		ADCDATA                  : out std_logic_vector(31 downto 0)
	);
end component audio_interface;

-- Clock
signal CLOCK : std_logic;

-- internal signals for the audio_interface inputs
signal LDATASig, RDATASig : std_logic_vector(15 downto 0);
signal ResetSig, INITSig, AUD_BCLKSig, AUD_ADCDATSig, AUD_DACLRCKSig, AUD_ADCLRCKSig : std_logic;

-- internal signals for the audio_interface outputs
signal  ADCDATASig  : std_logic_vector(31 downto 0); -- DONT NEED THIS 
signal  adc_fullSig : std_logic;                     -- DONT NEED THIS
signal  INIT_FINISHSig, data_overSig, AUD_MCLKSig, AUD_DACDATSig, I2C_SDATSig, I2C_SCLKSig: std_logic;

-- other internal signals
signal SWITCHESSig    : std_logic_vector(17 downto 0);
signal t              : std_logic_vector(15 downto 0); -- for shift music (may remove this)
--signal freq           : std_logic_vector(15 downto 0);
signal ADDRSig        : std_logic_vector(17 downto 0);
signal RAM_DATASig    : std_logic_vector(15 downto 0);
signal readReady      : std_logic_vector(1 downto 0);
signal was_checked    : std_logic;
signal Mem_LB, Mem_UB, Mem_WE, Mem_CE, Mem_OE : std_logic;

-- explosion sound signals
signal explode_timer  : std_logic_vector(23 downto 0);
signal explosion_freq : std_logic_vector(15 downto 0);
signal explosion_sig  : std_logic;
signal explosion_playing  : std_logic;
signal explosion_fin  : std_logic;
signal explosion_toggle : std_logic_vector(2 downto 0);

-- bomb placement sound signals
signal place_timer    : std_logic_vector(22 downto 0);
signal place_freq1     : std_logic_vector(15 downto 0);
signal place_freq2     : std_logic_vector(15 downto 0);
signal place_sig      : std_logic;
signal place_playing  : std_logic;
signal place_fin      : std_logic;
signal place_toggle   : std_logic_vector(2 downto 0);

-- death/exit sound signals
signal death_timer    : std_logic_vector(24 downto 0);
signal death_freq1    : std_logic_vector(15 downto 0);
signal death_freq2    : std_logic_vector(15 downto 0);
--signal death_freq3    : std_logic_vector(15 downto 0); -- we decided to only use two frequencies for this sound
--signal death_freq4    : std_logic_vector(15 downto 0);
signal death_sig      : std_logic;
signal death_playing  : std_logic;
signal death_fin      : std_logic;
signal death_toggle   : std_logic_vector(2 downto 0);

begin

-- Use both bytes, never write. (RAM signals)
Mem_LB   <= '0';
Mem_UB   <= '0';
Mem_WE   <= '1';
Mem_CE   <= '0';

-- Connect the internals
-- Coming IN
CLOCK          <= CLK;
ResetSig       <= Reset;
AUD_BCLKSig    <= AUD_BCLK;
AUD_ADCDATSig  <= AUD_ADCDAT;
AUD_DACLRCKSig <= AUD_DACLRCK;
AUD_ADCLRCKSig <= AUD_ADCLRCK;
--SWITCHESSig    <= SWITCHES; -- used for debugging

-- ADCDATA    <= ADCDATASig; -- used for debugging

-- Other Specific Mappings
INITSig <= SW0; -- leftmost switch will be initilization trigger (used for debugging)

-- connecting signal inputs to internal signals
explosion_sig <= EXPLOSION_SOUND;
place_sig     <= BOMB_PLACE_SOUND;
death_sig     <= DEATH_SOUND;

---explosion_sig  <= SWITCHESSig(16);
---place_sig <= SWITCHESSig(15);
---death_sig <= SWITCHESSig(14);


-- port mappings
audio_interfaceInstance : audio_interface
Port Map(
		LDATA        => LDATASig,
        RDATA        => RDATASig,
		clk          => CLK,
        Reset        => ResetSig,
        INIT         => INITSig,
		INIT_FINISH  => INIT_FINISHSig,
		adc_full     => adc_fullSig,
		data_over    => data_overSig,
		AUD_MCLK     => AUD_MCLKSig,
		AUD_BCLK     => AUD_BCLKSig,
		AUD_ADCDAT   => AUD_ADCDATSig,
		AUD_DACDAT   => AUD_DACDATSig,
		AUD_DACLRCK  => AUD_DACLRCKSig,
        AUD_ADCLRCK  => AUD_ADCLRCKSig,
		I2C_SDAT     => I2C_SDATSig,
		I2C_SCLK     => I2C_SCLKSig,
		ADCDATA      => ADCDataSig
);

-- To feed data to the DAC, left channel data must be fed (16-bit two's complement) into LDATA.
-- Right channel data must be fed (16-bit two's complement) into RDATA.
-- When a single sample has been fed correctly into the DAC, data_over is raised high.
-- When the next sample begins being read out, data_over is again lowered.

-- more debug signals
--LEDS(17) <= INITSig;
--LEDS(16) <= INIT_FINISHSig;
--LEDS(15) <= Mem_OE;
--LEDS(14) <= data_overSig;


-- Delegate is a control process that `delegates' when a sound is allowed to play. For example, 
-- each sound has three control signals: sig, fin, and playing. When 'sig' is high, it is
-- interpreted as being a `play request'. when 'fin' is high, it means that the sound is not
-- currently being sent to the DAC. This process is used to set the value of the 'playing' signals
-- appropriately.

-- The 'playing' signals are used in the ProcessSoundEffect process and keep the sound playing until
-- the sound delay time ends.

Delegate : process(CLOCK, ResetSig, explosion_playing, explosion_sig, explosion_fin, place_sig, place_playing, place_fin, death_playing,death_sig, death_fin)
begin

    if(ResetSig = '1') then
        explosion_playing <= '0';
        place_playing     <= '0';
    end if;

    if(explosion_sig = '1' and explosion_fin = '0') then
        explosion_playing <= '1';
    elsif(explosion_sig = '1' and explosion_fin = '1') then
        explosion_playing <= '1';
    elsif(explosion_sig = '0' and explosion_fin = '0') then
        explosion_playing <= '1';
    else
        explosion_playing <= '0';
    end if;
        
    if(place_sig = '1' and place_fin = '0') then
        place_playing <= '1';
    elsif(place_sig = '1' and place_fin = '1') then
        place_playing <= '1';
    elsif(place_sig = '0' and place_fin = '0') then
        place_playing <= '1';
    else
        place_playing <= '0';
    end if;
    
    if(death_sig = '1' and death_fin = '0') then
        death_playing <= '1';
    elsif(death_sig = '1' and death_fin = '1') then
        death_playing <= '1';
    elsif(death_sig = '0' and death_fin = '0') then
        death_playing <= '1';
    else
        death_playing <= '0';
    end if;
    
end process;

--LEDS(0) <= death_playing;
--LEDS(1) <= death_sig;
--LEDS(2) <= death_fin;

-- ProcessSoundEffects acts as the 'timing' handler for all of the sound effects. Each sound effect has a duration, and the process
-- does the necessary checking and assigning needed to make sure that the sounds continue to play until their duration expires.

-- Each sound as associated 'freq' variables, which describe the frequency of the tones generated. This is done with a sawtooth wave,
-- as described in our final report.
ProcessSoundEffects : process (CLOCK, ResetSig, explosion_toggle, death_toggle, place_toggle, place_playing, death_playing, explosion_playing)
begin
    if (ResetSig = '1') then
        t    <= "0000000000000000";
        --freq <= "0000000000000000";
        explosion_toggle <= "000";
        place_toggle     <= "000";
        death_timer   <= "0000000000000000000000000";
        explode_timer <= "000000000000000000000000";
        place_timer   <= "00000000000000000000000";
        place_fin     <= '1';
        death_fin     <= '1';
        explosion_freq    <= "0000000000000001"; -- this results in a bomb sound
        explosion_fin     <= '1';
        place_freq1       <= "0000000000000001";
        place_freq2       <= "0000000000000010";
        death_freq1       <= "0000000000010000";
        death_freq2       <= "0000000100010010";
    elsif(rising_edge(CLOCK)) then

        explosion_freq    <= explosion_freq;
        place_freq1       <= place_freq1;
        place_freq2       <= place_freq2;
        death_freq1       <= death_freq1;
        death_freq2       <= death_freq2;
        
        -- Since explode_timer starts as all zeros, checking when the counter gets to all ones will occur at a computable delay based on
        -- the 60 MHz clock. This is further described in our final project report.
        
        if(explode_timer /= "111111111111111111111111" and explosion_playing = '1') then
            explosion_fin <= '0';
            
            -- this is a trick we devised to raise and lower the frequency of the tones that are generated. By maintaining another
            -- 'internal' counter, we can change the slope of the sawtooth wave, which in effect changes the period. Changing the period
            -- of the wave changes the pitch that we hear. Essentially, we can 'steer' the frequency by changing the size of the toggle.
            if(explosion_toggle = "000") then
                t  <= t + explosion_freq; -- the effect of this causes a sawtooth wave in time, because of integer overflow.
            else
                t  <= t;
            end if;
            explosion_toggle <= explosion_toggle + 1; -- increment the 'frequency steering' signal
            explode_timer <= explode_timer + 1; -- increment the master explode sound counter
        elsif(explode_timer = "111111111111111111111111") then -- once the counter gets to all ones, stop the sound from playing.
            explode_timer <= "000000000000000000000000"; -- reset the timer
            explosion_fin <= '1'; -- 'sound is over'
        end if;
 
        if(place_timer /= "11111111111111111111111" and place_playing = '1') then -- same idea as the explosion sound.
            place_fin <= '0';
            if(place_toggle = "000") then
            
                if(place_timer >= "10000000001000000000000") then
                    t  <= t + place_freq1;
                else
                    t  <= t + place_freq2;
                end if;               
            else
                t  <= t;
            end if;
            place_toggle <= place_toggle + 1;
            place_timer <= place_timer + 1;
        elsif(place_timer = "11111111111111111111111") then
            place_timer  <= "00000000000000000000000";
            place_fin <= '1';
        end if;
        
         if(death_timer /= "1111111111111111111111111" and death_playing = '1') then -- same idea as the explosion sound.
            death_fin <= '0';
            if(death_toggle = "000") then
                if(death_timer >= "00000000000000100000000000") then
                    t  <= t + death_freq1;
                else
                    t  <= t + death_freq2;
                end if; 
            else
                t  <= t;
            end if;
            death_toggle <= death_toggle + 1;
            death_timer <= death_timer + 1;
        elsif(death_timer = "1111111111111111111111111") then
            death_timer <= "0000000000000000000000000";
            death_fin <= '1';
        end if;
        
    end if;
end process;

-- SoundLoop is a logistical process that takes the current retrieved sample from the SRAM and loads it into the DAC registers.
-- To play both music and sound effects at the same time, we use both the left and right sound channels. Sound effects are loaded 
-- into the left channel, and the music is piped into the right channel.
SoundLoop : process (CLOCK, ResetSig, INITSig, RAM_DATASig, t, data_overSig)
begin
    if (ResetSig = '1') then
        --freq    <= "0000000000000000"; -- old debug signal.
    elsif(rising_edge(CLOCK)) then
        --freq    <= SWITCHESSig(15 downto 0); -- old debugging code.
        if(INIT_FINISHSig = '1') then
            if (data_overSig = '0') then -- Send data when DAC is ready for more bits.
                RDATASig   <= RAM_DATASig;
                --LDATASig   <= RAM_DATASig;
                LDATASig   <= t(15 downto 0);
                
                --RDataSig(15 downto 8) <= RAMDataSig(7 downto 0); -- these were old debug signals.
                --LDATASig   <= s & t(14 downto 0); -- arithmetic right shift 1
                --RDATASig <= s & t(14 downto 0); -- arithmetic right shift 1
             else
                RDataSig   <= RDataSig;
                LDataSig   <= LDataSig;
            end if;
        end if;
    end if;
end process;

-- GetNextSample interacts directly with the SRAM to retreive a 16 bit wave file sample. This is a fairly complicated
-- process, because the clock, RAM sample retreival, and DAC playout mechanics all occur at different rates. Therefore,
-- there needs to be checking code in place to detect when things are 'ready' and 'not ready', and the appropriate actions
-- need to take place.

-- Since the wave file samples are stored in sequential order on the SRAM, we essentially need to send the memory of each
-- address to the DAC, and when it completes, increment the address by one, do it again, etc. the audio_interface entity sets
-- its output signal data_over to high when it is ok to send in the next playout sample. When this occurs, we increment the
-- SRAM address by one. Otherwise, we keep the ram address the same.

-- We also need to jump over the header, and loop the sound. This is as easy as checking to see if the address is equal to
-- the last sample we wish to play, and if so, resetting the address to the first sample (past the header).
GetNextSample: process(CLOCK, ResetSig, data_overSig, was_checked, ADDRSig, RAM_DATA)
begin
    if (ResetSig = '1') then
        ADDRSig <= "000000000000111111"; -- start the address 'past' the header of the wave file on the SRAM.
        Mem_OE  <= '1';
        readReady  <= "00";
        was_checked <= '0';
    elsif(rising_edge(CLOCK)) then        
        if(readReady = "00") then
            Mem_OE   <= '0';            -- Tell the ram to retreive the address. (Active low!)
            RAM_DATASig <= RAM_DATA;
            if(data_overSig = '1' and was_checked = '0' and ADDRSig < x"031F4F") then-- and was_checked = '0') then -- Pick the next sample address if the sound driver is ready.           
                    ADDRSig <= ADDRSig + 2;
                    was_checked <= '1';
            elsif(data_overSig = '1' and was_checked = '0' and ADDRSig >= x"031F4F") then
                    ADDRSig <= "000000000000111111";
                    was_checked <= '1';            
            else
                if(data_overSig = '1' and was_checked = '1') then
                   was_checked <= '1';
                else
                    was_checked <= '0';
                end if;
                             
                Mem_OE      <= '0';
                ADDRSig     <= ADDRSig;     -- Otherwise, just retreive the same sample.
                RAM_DATASig <= RAM_DATA;
            end if;
            
         end if;
        
        readReady <= readReady + 1;
        
    end if;    

end process;
      
-- Going OUT
AUD_MCLK   <= AUD_MCLKSig;
AUD_DACDAT <= AUD_DACDATSig;
I2C_SDAT   <= I2C_SDATSig;
I2C_SCLK   <= I2C_SCLKSig;
LB         <= Mem_LB;
UB         <= Mem_UB;
WE         <= Mem_WE;
CE         <= Mem_CE;
OE         <= Mem_OE;
ADDR       <= ADDRSig;

end Behavioral;

