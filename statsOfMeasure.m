%function [stats] = statsOfMeasure(confusion, verbatim)
function [values] = statsOfMeasure(confusion, verbatim)


% A entrada 'confusion' é a saída da função Matlab 'confusionmat'
% E se 'verbatim' = 1; saída da tabela gerada na janela de comando

% confusion: 3x3 confusion matrix
tp = [];
fp = [];
fn = [];
tn = [];
len = size(confusion, 1);
for k = 1:len                  %  predict
    % Verdadeiros positivos           % | x o o |
    tp_value = confusion(k,k); % | o o o | true
    tp = [tp, tp_value];       % | o o o |
                                               %  predict
    % Falso-positivo                          % | o o o |
    fp_value = sum(confusion(:,k)) - tp_value; % | x o o | true
    fp = [fp, fp_value];                       % | x o o |
                                               %  predict
    % Falsos negativos                          % | o x x |
    fn_value = sum(confusion(k,:)) - tp_value; % | o o o | true
    fn = [fn, fn_value];                       % | o o o |
                                                                       %  predict
    % Verdadeiros negativos (todo o resto)                                    % | o o o |
    tn_value = sum(sum(confusion)) - (tp_value + fp_value + fn_value); % | o x x | true
    tn = [tn, tn_value];                                               % | o x x |
end

% Estatísticas de interesse para matriz de confusão

prec = tp ./ (tp + fp); % precisão
sens = tp ./ (tp + fn); % sensibilidade, lembrança
spec = tn ./ (tn + fp); % especificidade
acc = sum(tp) ./ sum(sum(confusion));
f1 = (2 .* prec .* sens) ./ (prec + sens);

% Para micro-média
microprec = sum(tp) ./ (sum(tp) + sum(fp)); % precisão
microsens = sum(tp) ./ (sum(tp) + sum(fn)); % sensibilidade, lembrança
microspec = sum(tn) ./ (sum(tn) + sum(fp)); % especificidade
microacc = acc;
microf1 = (2 .* microprec .* microsens) ./ (microprec + microsens);

% Nomes das linhas
name = ["true_positive"; "false_positive"; "false_negative"; "true_negative"; ...
    "precision"; "sensitivity"; "specificity"; "accuracy"; "F-measure"];

% Nomes das colunas
varNames = ["name"; "classes"; "macroAVG"; "microAVG"];

% Valores das colunas para cada classe
values = [tp; fp; fn; tn; prec; sens; spec; repmat(acc, 1, len); f1];

% Macro-média
macroAVG = mean(values, 2);

% Micro-média
microAVG = [macroAVG(1:4); microprec; microsens; microspec; microacc; microf1];

% SAÍDA: mesa final
stats = table(name, values, macroAVG, microAVG, 'VariableNames',varNames);
if verbatim
    stats
end
end