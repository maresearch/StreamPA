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

fraw0 = 'rawdata10G';   %��ȡ�������ԭʼ����
fpsu0 = 'PsuRD';      %��ȡ��ǰ���ɵ�pseudo random string
ffinal0 = 'FinalRD';   %����֮�������д���ļ�����

path = 'D:\Xingjian Zhang\Work\X13 ���ܱ���\Programs';
fraw=fopen([path '\' fraw0],'r');  %���ļ����Զ����ƶ�ȡ��ʽ���ʣ�'r':��Ҫ��ȡ���ļ�
fpsu=fopen([path '\' fpsu0],'r');
ffinal=fopen([path '\' ffinal0],'w');     %д���ļ�·�� ��'w':�򿪻򴴽�Ҫд������ļ�
if ffinal == -1   %-1:�޷����ļ�
    mkdir(path);  %make new folder
    ffinal = fopen([path '\' ffinal0],'w+');   %'w+':�򿪻򴴽�Ҫ��д�����ļ�
end

n = 128*1024/64;         %ÿ��д�������������Ӧ�ڴ������raw data����

res = zeros(1,n);
Rawbitn(1:n) = fread(fraw,n,'ubit1');
Pseubitn(1:n) = fread(fpsu,n,'ubit1');
% 
% tic;
% res(Rawbitn ~= Pseubitn)=1;
% processtime=toc
% fwrite(ffinal,res(1:n),'ubit1');


tic;
for i=1:64000  %ѭ������*n = �ܵĴ�����raw data����
%     now=i;
%     res = zeros(1,n);
%     Rawbitn(1:n) = fread(fraw,n,'ubit1');   
%     Pseubitn(1:n) = fread(fpsu,n,'ubit1');
%     %processtime1 = cputime;
%     %D = mod(Rawbitn+Pseubitn,2);   %����XOR����
    res(Rawbitn ~= Pseubitn)=1;
%     %processtime1 = cputime-processtime1;
%     %fwrite(ffinal,D(1:n),'ubit1');    %д��final data
%     fwrite(ffinal,res(1:n),'ubit1');    %д��final data
% %     fwrite(ffinal,zeros(n),'ubit1');    %д��final data
end
processtime=toc

statusraw=fclose(fraw);
statuskey=fclose(fpsu);
statuswrd=fclose(ffinal);
