function [spec, diffspec] = oneDir(FS, sync, data, chirp, BW, zpad,offsetBegin,offsetEnd,ref)
%% constants
c = 3E8; %(m/s) speed of light

%% system parameters
%chirp=66; % (Hz) frequency of chirp signal

%% read audio data
%[Y,FS] = audioread('Rectest-03.wav');
%sync=Y(:,1);
%data=Y(:,2);

%% get reference data
% fid = fopen('ref.dat');
% REF = textscan(fid,'%f');
% fclose(fid);
% ref=REF{1}';

%% data prepare
%BW=300E6;
N=fix(FS/chirp)-offsetEnd;
%rr = c/(2*BW);
thresh = 0.4;

%%
count=0;
start=(sync<thresh);
for ii = 100:(size(start,1)-N)
    if start(ii) == 1 && mean(start(ii-2:ii-1)) == 0
        %start2(ii) = 1;
        count = count + 1;
        sif(count,:) = data(ii+offsetBegin:ii+N-1);
        time(count) = ii*1/FS;
    end
end

%% subtract the reference
% for ii = 1:size(sif,1);
%     sif(ii,:) = sif(ii,:) - ref(offset:N-1);
% end

%% subtract the mean
% ave = mean(sif,1);
% for ii = 1:size(sif,1);
%     sif(ii,:) = sif(ii,:) - ave;
% end

avey=mean(sif,2);
for jj = 1:size(sif,2);
    sif(:,jj) = sif(:,jj) - avey;
end

%% FFT
%zpad = 20*N;

%RTI plot
% figure(1);
% %v = dbv(fft(sif,zpad,2));
% v = abs(fft(sif,zpad,2));
% S = v(:,1:size(v,2)/2);
% m = max(max(v));
% %imagesc(linspace(0,max_range,zpad),time,S-m,[-20,0]);
% imagesc(linspace(0,max_range,zpad/2),time,S/m,[0,1]);
% colorbar;
% colormap hot;
% ylabel('time (s)');
% xlabel('range (m)');
% title('Range vs. Time Intensity');

%% average
%avg=mean(sif,1)- ref(offset:N-1);
avg=mean(sif,1);
avg=avg.*taylorwin(length(avg))';
spec=abs(fft(avg,zpad));
%spec=20*log10(spec(1:zpad/2)/max(max(spec)));
spec=20*log10(spec(1:zpad/2));

spect=abs(fft(sif,zpad,2));
diffspec=std(spect,0,1);
%maxdata=max(spect,[],1);
%mindata=min(spect,[],1);
%diffspec=maxdata-mindata;
diffspec=20*log10(diffspec(1:zpad/2));
%f2=(0:zpad-1)*FS/zpad;
%plot(f2(1:zpad/2),spec(1:zpad/2));



