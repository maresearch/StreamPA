%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   File name:      XORFinal
%   Project:        Stream Privacy Amplification
%   Copyright by:   Xingjian Zhang @ THU
%   Date:           2021-09-02
%   Function:       XOR the raw data and the pseudo random string
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%clc;
clear all;
maxNumCompThreads(1);

fraw0 = 'rawdata10G';   %读取待处理的原始数据
fpsu0 = 'PsuRD';      %读取先前生成的pseudo random string
ffinal0 = 'FinalRD';   %处理之后的数据写入文件名称

path = 'D:\Xingjian Zhang\Work\X13 国盾比赛\Programs';
fraw=fopen([path '\' fraw0],'r');  %打开文件，以二进制读取形式访问；'r':打开要读取的文件
fpsu=fopen([path '\' fpsu0],'r');
ffinal=fopen([path '\' ffinal0],'w');     %写入文件路径 ；'w':打开或创建要写入的新文件
if ffinal == -1   %-1:无法打开文件
    mkdir(path);  %make new folder
    ffinal = fopen([path '\' ffinal0],'w+');   %'w+':打开或创建要读写的新文件
end

n = 128*1024/64;         %每次写入的数据量，对应于待处理的raw data长度

res = zeros(1,n);
Rawbitn(1:n) = fread(fraw,n,'ubit1');
Pseubitn(1:n) = fread(fpsu,n,'ubit1');
% 
% tic;
% res(Rawbitn ~= Pseubitn)=1;
% processtime=toc
% fwrite(ffinal,res(1:n),'ubit1');


tic;
for i=1:64000  %循环次数*n = 总的待处理raw data长度
%     now=i;
%     res = zeros(1,n);
%     Rawbitn(1:n) = fread(fraw,n,'ubit1');   
%     Pseubitn(1:n) = fread(fpsu,n,'ubit1');
%     %processtime1 = cputime;
%     %D = mod(Rawbitn+Pseubitn,2);   %进行XOR操作
    res(Rawbitn ~= Pseubitn)=1;
%     %processtime1 = cputime-processtime1;
%     %fwrite(ffinal,D(1:n),'ubit1');    %写入final data
%     fwrite(ffinal,res(1:n),'ubit1');    %写入final data
% %     fwrite(ffinal,zeros(n),'ubit1');    %写入final data
end
processtime=toc

statusraw=fclose(fraw);
statuskey=fclose(fpsu);
statuswrd=fclose(ffinal);
