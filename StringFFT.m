%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   File name:      StringFFT
%   Project:        Stream Privacy Amplification
%   Copyright by:   Xingjian Zhang @ THU
%   Date:           2021-09-01
%   Function:       Generate a pseudo random string
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%clc;
clear all;
maxNumCompThreads(1);   %���Ƶ���

ftoe0 = 'randomdata5G';   %���ڲ���Toeplitz����FFTʱΪ������������
fseed0 = 'randomdata1G';      %������չ����pseudo string������
fpsu0 = 'PsuRD';   %����֮�������д���ļ�����

path = 'D:\Xingjian Zhang\Work\X13 ���ܱ���\Programs';   %�ļ�·��
fseed=fopen([path '\' fseed0],'r');  %���ļ����Զ����ƶ�ȡ��ʽ���ʣ�'r':��Ҫ��ȡ���ļ�
ftoe=fopen([path '\' ftoe0],'r');
fpsu=fopen([path '\' fpsu0],'w');     %д���ļ�·�� ��'w':�򿪻򴴽�Ҫд������ļ�
if fpsu == -1   %-1:�޷����ļ�
    mkdir(path);  %make new folder
    fpsu = fopen([path '\' fpsu0],'w+');   %'w+':�򿪻򴴽�Ҫ��д�����ļ�
end

n = 1280;         %ÿ��д�������������Ӧ�ڴ������raw data����
k = 0.8 * n;      %raw data��min-entropy
m = n-k;    %ÿ��ʹ�õ�seed����
L = n+m-1;    %Toeplitz������������

RawbitL = zeros(L,1);
ToeSeed = fread(ftoe,L,'ubit1');

processtime0 = cputime;
for i=1:1024*100  %ѭ������*n = �ܵĴ�����raw data����
now=i;
RawbitL(1:m) = fread(fseed,m,'ubit1');   %����m-bit������չ������
processtime1 = cputime;
D = mod(round(ifft((fft(ToeSeed).*fft(RawbitL)))),2);   % fft:���ٸ���Ҷ�仯��ifft:����ٸ���Ҷ�仯��round���������룻mod:ȡ����
processtime1 = cputime-processtime1;
fwrite(fpsu,D(1:n),'ubit1');    %д����չ���pseudo random string
end

processtime = cputime-processtime0    % ����ʱ�����
statusraw=fclose(fseed);
statuskey=fclose(ftoe);
statuswrd=fclose(fpsu);
