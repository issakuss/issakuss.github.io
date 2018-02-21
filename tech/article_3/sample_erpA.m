%% -- �T���v���v���O����(A) -- %%

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

stimList = [zeros(1, N - N_targ0et), ones(1, N_target)]; % �h�����X�g�𐶐�
stimList = stimList(randperm(length(stimList)));    % �h���̏��Ԃ������_����


%% �h���掦�J�n
disp('EXP. START!')
for i = 1:N    % �iMATLAB�ɂ����� i �͋����������̂Ŏg��Ȃ��ق������������ł����c�j
    % �h���掦�Ԋu
    inlet.pull_chunk(); % �]�g����J�n
    t1 = GetSecs();  % ���Ԃ̑�����J�n
    t2 = GetSecs();    
    while t2 - t1 < interval - after % �h���掦�Ԋu�Ɏw�肵�����Ԃ��߂���܂ő҂�
        t2 = GetSecs();
        pause(0.01)
    end
    % �h���掦
    disp(stimList(i))   % �h����掦
    t1 = GetSecs();
    t2 = GetSecs();
    while t2 - t1 < after % ���莞�Ԃ��߂���܂ő҂�
        t2 = GetSecs();
        pause(0.01)
    end
    eeg = inlet.pull_chunk();   % ���悻interval�b���̔]�g����������擾����
    % �]�g����
    eeg = eeg(61, end-(after+base)*sRate+1:end); % �Ō��after+base�b���́AOz�iHD-72�Ȃ�j�̔]�g��؂�o��
    detrend(movmean(eeg, 20));  % �ȒP�Ƀt�B���^�����O
    eeg = eeg - mean(eeg(1:base*sRate));    % �x�[�X���C���̕��ϒl��0�ɍ��킹��
    eegs(i, :) = eeg;   %�u���ꕨ�v�ɕۑ�    
end
disp('FINISHED!')


%% ���Z���ς��ăv���b�g
idx = stimList == 1;
erp = mean(eegs(idx, :));
plot(erp);
grid on
   