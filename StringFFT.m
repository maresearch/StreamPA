%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   File name:      StringFFT
%   Project:        Stream Privacy Amplification
%   Copyright by:   Xingjian Zhang @ THU
%   Date:           2021-09-01
%   Function:       Generate a pseudo random string
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%clc;
clear all;
maxNumCompThreads(1);   %限制单核

ftoe0 = 'randomdata5G';   %用于产生Toeplitz矩阵（FFT时为向量）的种子
fseed0 = 'randomdata1G';      %用于扩展生成pseudo string的种子
fpsu0 = 'PsuRD';   %处理之后的数据写入文件名称

path = 'D:\Xingjian Zhang\Work\X13 国盾比赛\Programs';   %文件路径
fseed=fopen([path '\' fseed0],'r');  %打开文件，以二进制读取形式访问；'r':打开要读取的文件
ftoe=fopen([path '\' ftoe0],'r');
fpsu=fopen([path '\' fpsu0],'w');     %写入文件路径 ；'w':打开或创建要写入的新文件
if fpsu == -1   %-1:无法打开文件
    mkdir(path);  %make new folder
    fpsu = fopen([path '\' fpsu0],'w+');   %'w+':打开或创建要读写的新文件
end

n = 1280;         %每次写入的数据量，对应于待处理的raw data长度
k = 0.8 * n;      %raw data中min-entropy
m = n-k;    %每次使用的seed长度
L = n+m-1;    %Toeplitz独立变量个数

RawbitL = zeros(L,1);
ToeSeed = fread(ftoe,L,'ubit1');

processtime0 = cputime;
for i=1:1024*100  %循环次数*n = 总的待处理raw data长度
now=i;
RawbitL(1:m) = fread(fseed,m,'ubit1');   %读入m-bit用于扩展的种子
processtime1 = cputime;
D = mod(round(ifft((fft(ToeSeed).*fft(RawbitL)))),2);   % fft:快速傅里叶变化；ifft:逆快速傅里叶变化；round：四舍五入；mod:取余数
processtime1 = cputime-processtime1;
fwrite(fpsu,D(1:n),'ubit1');    %写入扩展后的pseudo random string
end

processtime = cputime-processtime0    % 运行时间输出
statusraw=fclose(fseed);
statuskey=fclose(ftoe);
statuswrd=fclose(fpsu);
