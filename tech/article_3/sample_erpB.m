%% -- �T���v���v���O����(B) -- %%

%% �h���掦�̐ݒ�
N = 20; % �h���掦��
per_target = 0.25;   % �^�[�Q�b�g�h���̉񐔊���
base = 0.5; % �x�[�X���C���̎��� (sec)
after = 1;   % �h���掦��̑��莞�� (sec)
interval = 3;   % �h���掦�Ԋu (sec)


%% �]�g����̏���
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
eegs = zeros(N, sRate*(base+after));  % �]�g��ۑ�����u���ꕨ�v���h���掦�񐔕��p�ӂ���i�s���h���掦�񐔁j


%% �h������
N_target = floor(N*per_target);
stimList = [zeros(1, N - N_target), ones(1, N_target)]; % �h�����X�g�𐶐�
stimList = stimList(randperm(length(stimList)));    % �h���̏��Ԃ������_����


%% �h���^�C�~���O�L�^����
marks = zeros(1, N);

%% �h���掦�J�n
disp('EXP. START!')
inlet.pull_chunk();
pause(0.1)
startTime = GetSecs();
[~, startTime_eeg] = inlet.pull_chunk();  % �]�g����J�n, �J�n���̃^�C���X�^���v���擾
pause(3);   % �ۑ肪�n�܂�܂ŏ����Ԋu��������
for i = 1:N    % �iMATLAB�ɂ����� i �͋����������̂Ŏg��Ȃ��ق������������ł����c�j
    % �h���掦�Ԋu
    t1 = GetSecs();  % ���Ԃ̑�����J�n
    t2 = GetSecs();    
    % �h���掦
    disp(stimList(i))   % �h����掦
    marks(i) = GetSecs() - startTime;    % �h�����񎦂��ꂽ�Ƃ��̎��Ԃ��L�^
    while t2 - t1 < interval % �h���掦�Ԋu�Ɏw�肵�����Ԃ��߂���܂ő҂�
        t2 = GetSecs();
        pause(0.01)
    end    
end
[allEEG, ts] = inlet.pull_chunk();   % �ۑ�J�n�����獡�܂ł̔]�g�ƁA���̃^�C���X�^���v���擾
disp('FINISHED!')

%%  �]�g����
ts = ts - startTime_eeg(end);  % �J�n���̃^�C���X�^���v�ƍ������Ƃ�
for i = 1:N
    idx_mark = find(abs(marks(i) - ts) == min(abs(marks(i) - ts)));
    % ��i�Ԗڂ̎h�����\�����ꂽ�Ƃ��A����ڂ̔]�g�����肳�ꂽ�����������l
    %   �^�C���X�^���v�͊��S��v���Ȃ��̂ŁA�����ł����������̂�I��ł���
    idx = idx_mark-base*sRate+1 : idx_mark+after*sRate;
    % ��i�Ԗڂ̎h�����\�����ꂽ�Ƃ��̑Obase�ƌ�after�b�̔]�g������ڂɂ��邩������
    eeg = allEEG(61, idx);    % after+base�b���́AOz�iHD-72�Ȃ�j�̔]�g��؂�o��
    detrend(movmean(eeg, 20));  % �ȒP�Ƀt�B���^�����O
    eeg = eeg - mean(eeg(1:base*sRate));    % �x�[�X���C���̕��ϒl��0�ɍ��킹��
    eegs(i, :) = eeg;   %�u���ꕨ�v�ɕۑ�
end

%% ���Z���ς��ăv���b�g
idx = stimList == 1;
erp = mean(eegs(idx, :));
plot(erp);
grid on
   