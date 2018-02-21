%% -- サンプルプログラム(A) -- %%

%% 刺激呈示の設定
N = 20; % 刺激呈示回数
per_target = 0.25;   % ターゲット刺激の回数割合
base = 0.5; % ベースラインの時間 (sec)
after = 1;   % 刺激呈示後の測定時間 (sec)
interval = 3;   % 刺激呈示間隔 (sec)


%% 脳波測定の準備
if ~exist('arg_define','file')
    addpath(genpath(fileparts(mfilename('fullpath')))); end
if ~exist('env_translatepath','file')
    lib = lsl_loadlib();
else
    lib = lsl_loadlib(env_translatepath('dependencies:/liblsl-Matlab/bin'));
end
disp('Resolving an EEG stream...');
result = {};
while isempty(result)
    result = lsl_resolve_byprop(lib,'type','EEG'); end
inlet = lsl_inlet(result{1});
sRate = inlet.info.nominal_srate();
eegs = zeros(N, sRate*(base+after));  % 脳波を保存する「入れ物」を刺激呈示回数分用意する（行が刺激呈示回数）


%% 刺激生成
N_target = floor(N*per_target);

stimList = [zeros(1, N - N_targ0et), ones(1, N_target)]; % 刺激リストを生成
stimList = stimList(randperm(length(stimList)));    % 刺激の順番をランダムに


%% 刺激呈示開始
disp('EXP. START!')
for i = 1:N    % （MATLABにおいて i は虚数を示すので使わないほうがいいそうですが…）
    % 刺激呈示間隔
    inlet.pull_chunk(); % 脳波測定開始
    t1 = GetSecs();  % 時間の測定を開始
    t2 = GetSecs();    
    while t2 - t1 < interval - after % 刺激呈示間隔に指定した時間が過ぎるまで待つ
        t2 = GetSecs();
        pause(0.01)
    end
    % 刺激呈示
    disp(stimList(i))   % 刺激を呈示
    t1 = GetSecs();
    t2 = GetSecs();
    while t2 - t1 < after % 測定時間が過ぎるまで待つ
        t2 = GetSecs();
        pause(0.01)
    end
    eeg = inlet.pull_chunk();   % およそinterval秒分の脳波をいったん取得する
    % 脳波処理
    eeg = eeg(61, end-(after+base)*sRate+1:end); % 最後のafter+base秒分の、Oz（HD-72なら）の脳波を切り出す
    detrend(movmean(eeg, 20));  % 簡単にフィルタリング
    eeg = eeg - mean(eeg(1:base*sRate));    % ベースラインの平均値を0に合わせる
    eegs(i, :) = eeg;   %「入れ物」に保存    
end
disp('FINISHED!')


%% 加算平均してプロット
idx = stimList == 1;
erp = mean(eegs(idx, :));
plot(erp);
grid on
   