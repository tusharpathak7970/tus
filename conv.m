clc
clear all
close all
name='.jpg';
for i=1:6 
    
    frnt=num2str(i);
    file=strcat(frnt,name);
    inp=imread(file);
    inp=imresize(inp,[227 227]);
    imwrite(inp,file);
end