function [analysisNsoltLgraph,synthesisNsoltLgraph] = ...
    creatensoltlgraphs2d(varargin)
%FCN_CREATENSOLTLGRAPHS2D
%
% Imported and modified from SaivDr package
%
%    https://github.com/msiplab/SaivDr
%
% Requirements: MATLAB R2020a
%
% Copyright (c) 2020, Shogo MURAMATSU
%
% All rights reserved.
%
% Contact address: Shogo MURAMATSU,
%                Faculty of Engineering, Niigata University,
%                8050 2-no-cho Ikarashi, Nishi-ku,
%                Niigata, 950-2181, JAPAN
%
% http://msiplab.eng.niigata-u.ac.jp/
%
import msip.*
p = inputParser;
addParameter(p,'NumberOfChannels',[2 2])
addParameter(p,'DecimationFactor',[2 2])
addParameter(p,'PolyPhaseOrder',[0 0])
addParameter(p,'NumberOfLevels',1);
addParameter(p,'NumberOfVanishingMoments',1);
parse(p,varargin{:})

% Layer constructor function goes here.
nChannels = p.Results.NumberOfChannels;
decFactor = p.Results.DecimationFactor;
ppOrder = p.Results.PolyPhaseOrder;
nLevels = p.Results.NumberOfLevels;
noDcLeakage = p.Results.NumberOfVanishingMoments;

if nChannels(1) ~= nChannels(2)
    throw(MException('NsoltLayer:InvalidNumberOfChannels',...
        '[%d %d] : Currently, Type-I NSOLT is only suported, where the even and odd channel numbers should be the same.',...
        nChannels(1),nChannels(2)))
end
if mod(prod(decFactor),2) ~= 0
    throw(MException('NsoltLayer:InvalidDecimationFactors',...
        '%d x %d : Currently, even decimation ratio is only supported.',...
        decFactor(1),decFactor(2)))
end
if any(mod(ppOrder,2))
    throw(MException('NsoltLayer:InvalidPolyPhaseOrder',...
        '%d + %d : Currently, even polyphase orders are only supported.',...
        ppOrder(1),ppOrder(2)))
end

for iLv = 1:nLevels
    strLv = sprintf('Lv%0d_',iLv);
    
    % Initial blocks
    analysisLayers = [
        nsoltBlockDct2dLayer('Name',[strLv 'E0'],...
        'DecimationFactor',decFactor)
        nsoltInitialRotation2dLayer('Name',[strLv 'V0'],...
        'NumberOfChannels',nChannels,'DecimationFactor',decFactor,...
        'NoDcLeakage',noDcLeakage)
        ];
    synthesisLayers = [
        nsoltBlockIdct2dLayer('Name',[strLv 'E0~'],...
        'DecimationFactor',decFactor)
        nsoltFinalRotation2dLayer('Name',[strLv 'V0~'],...
        'NumberOfChannels',nChannels,'DecimationFactor',decFactor,...
        'NoDcLeakage',noDcLeakage)
        ];
    
    % Atom extension in horizontal
    for iOrderH = 2:2:ppOrder(2)
        analysisLayers = [ analysisLayers
            nsoltAtomExtension2dLayer('Name',[strLv 'Qh' num2str(iOrderH-1) 'rl'],...
            'NumberOfChannels',nChannels,'Direction','Right','TargetChannels','Lower')
            nsoltIntermediateRotation2dLayer('Name',[strLv 'Vh' num2str(iOrderH-1)],...
            'NumberOfChannels',nChannels,'Mode','Analysis','Mus',-1)
            nsoltAtomExtension2dLayer('Name',[strLv 'Qh' num2str(iOrderH) 'lu'],...
            'NumberOfChannels',nChannels,'Direction','Left','TargetChannels','Upper')
            nsoltIntermediateRotation2dLayer('Name',[strLv 'Vh' num2str(iOrderH) ],...
            'NumberOfChannels',nChannels,'Mode','Analysis')
            ];
        synthesisLayers = [ synthesisLayers
            nsoltAtomExtension2dLayer('Name',[strLv 'Qh' num2str(iOrderH-1) 'rl~'],...
            'NumberOfChannels',nChannels,'Direction','Left','TargetChannels','Lower')
            nsoltIntermediateRotation2dLayer('Name',[strLv 'Vh' num2str(iOrderH-1) '~'],...
            'NumberOfChannels',nChannels,'Mode','Synthesis','Mus',-1)
            nsoltAtomExtension2dLayer('Name',[strLv 'Qh' num2str(iOrderH) 'lu~'],...
            'NumberOfChannels',nChannels,'Direction','Right','TargetChannels','Upper')
            nsoltIntermediateRotation2dLayer('Name',[strLv 'Vh' num2str(iOrderH) '~'],...
            'NumberOfChannels',nChannels,'Mode','Synthesis')
            ];
    end
    % Atom extension in vertical
    for iOrderV = 2:2:ppOrder(1)
        analysisLayers = [ analysisLayers
            nsoltAtomExtension2dLayer('Name',[strLv 'Qv' num2str(iOrderV-1) 'dl'],...
            'NumberOfChannels',nChannels,'Direction','Down','TargetChannels','Lower')
            nsoltIntermediateRotation2dLayer('Name',[strLv 'Vv' num2str(iOrderV-1)],...
            'NumberOfChannels',nChannels,'Mode','Analysis','Mus',-1)
            nsoltAtomExtension2dLayer('Name',[strLv 'Qv' num2str(iOrderV) 'uu'],...
            'NumberOfChannels',nChannels,'Direction','Up','TargetChannels','Upper')
            nsoltIntermediateRotation2dLayer('Name',[strLv 'Vv' num2str(iOrderV)],...
            'NumberOfChannels',nChannels,'Mode','Analysis')
            ];
        synthesisLayers = [ synthesisLayers
            nsoltAtomExtension2dLayer('Name',[strLv 'Qv' num2str(iOrderV-1) 'dl~'],...
            'NumberOfChannels',nChannels,'Direction','Up','TargetChannels','Lower')
            nsoltIntermediateRotation2dLayer('Name',[strLv 'Vv' num2str(iOrderV-1) '~'],...
            'NumberOfChannels',nChannels,'Mode','Synthesis','Mus',-1)
            nsoltAtomExtension2dLayer('Name',[strLv 'Qv' num2str(iOrderV) 'uu~'],...
            'NumberOfChannels',nChannels,'Direction','Down','TargetChannels','Upper')
            nsoltIntermediateRotation2dLayer('Name',[strLv 'Vv' num2str(iOrderV) '~'],...
            'NumberOfChannels',nChannels,'Mode','Synthesis')
            ];
    end
    % Channel separation and concatenation
    if iLv < nLevels
        analysisLayers = [ analysisLayers
            nsoltChannelSeparation2dLayer('Name',[strLv 'Sp'])
            ];
        synthesisLayers = [ synthesisLayers
            nsoltChannelConcatenation2dLayer('Name',[strLv 'Cn'])
            ];
    end
    if iLv == 1
        analysisNsoltLgraph = layerGraph(analysisLayers);
        synthesisNsoltLgraph = layerGraph(synthesisLayers(end:-1:1));
    else
        analysisNsoltLgraph = analysisNsoltLgraph.addLayers(analysisLayers);
        synthesisNsoltLgraph = synthesisNsoltLgraph.addLayers(synthesisLayers(end:-1:1));
    end
    if iLv > 1
        strLvPre = sprintf('Lv%0d_',iLv-1);
        analysisNsoltLgraph = analysisNsoltLgraph.connectLayers([strLvPre 'Sp/dc'],[strLv 'E0'] );
        analysisNsoltLgraph = analysisNsoltLgraph.addLayers(nsoltIdentityLayer('Name',[strLvPre 'AcOut']));
        analysisNsoltLgraph = analysisNsoltLgraph.connectLayers([strLvPre 'Sp/ac'],[strLvPre 'AcOut']);
        synthesisNsoltLgraph = synthesisNsoltLgraph.connectLayers([strLv 'E0~'],[strLvPre 'Cn/dc']);
        synthesisNsoltLgraph = synthesisNsoltLgraph.addLayers(nsoltIdentityLayer('Name',[strLvPre 'AcIn']));
        synthesisNsoltLgraph = synthesisNsoltLgraph.connectLayers([strLvPre 'AcIn'],[strLvPre 'Cn/ac']);
    end
end
analysisNsoltLgraph = analysisNsoltLgraph.addLayers(nsoltIdentityLayer('Name','Lv1_In'));
analysisNsoltLgraph = analysisNsoltLgraph.connectLayers('Lv1_In','Lv1_E0');
%
analysisNsoltLgraph = analysisNsoltLgraph.addLayers(nsoltIdentityLayer('Name',[strLv 'DcAcOut']));
if ppOrder(1) > 0
    analysisNsoltLgraph = analysisNsoltLgraph.connectLayers([strLv 'Vv' num2str(ppOrder(1))],[strLv 'DcAcOut']);
elseif ppOrder(2) > 0
    analysisNsoltLgraph = analysisNsoltLgraph.connectLayers([strLv 'Vh' num2str(ppOrder(2))],[strLv 'DcAcOut']);    
else
    analysisNsoltLgraph = analysisNsoltLgraph.connectLayers([strLv 'V0'],[strLv 'DcAcOut']);        
end
%
synthesisNsoltLgraph = synthesisNsoltLgraph.addLayers(nsoltIdentityLayer('Name','Lv1_Out'));
synthesisNsoltLgraph = synthesisNsoltLgraph.connectLayers('Lv1_E0~','Lv1_Out');
%
synthesisNsoltLgraph = synthesisNsoltLgraph.addLayers(nsoltIdentityLayer('Name',[strLv 'DcAcIn']));
if ppOrder(1) > 0
    synthesisNsoltLgraph = synthesisNsoltLgraph.connectLayers([strLv 'DcAcIn'],[strLv 'Vv' num2str(ppOrder(1)) '~']);
elseif ppOrder(2) > 0
    synthesisNsoltLgraph = synthesisNsoltLgraph.connectLayers([strLv 'DcAcIn'],[strLv 'Vh' num2str(ppOrder(2)) '~']);    
else
    synthesisNsoltLgraph = synthesisNsoltLgraph.connectLayers([strLv 'DcAcIn'],[strLv 'V0~']);    
end
end
