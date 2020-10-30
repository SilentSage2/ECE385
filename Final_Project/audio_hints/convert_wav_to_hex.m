[y,Fs] = audioread('main_theme_sped_up.wav','native');  //change the file name
% sound(y,Fs);
wavhex = lower(dec2hex(typecast(y, 'uint16')));
s='16''h ';
space=' ';
fileID = fopen('music.txt','w');

for x = 1:85115
    each_16=strcat(s,space,wavhex(x,:),',');
    fprintf(fileID,'%10s',each_16);

end

fclose(fileID);