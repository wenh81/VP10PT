classdef ChannelEleAWGN < ActiveModule
    % Copyright: (c)2011 (dawei.zju@gmail.com)
    % last modified @ 2014 , lingchen
    
    properties
        Input
        Output
        FrameOverlapRatio
        % DAC
        DACResolution
        % Rectpulse
        SymbolRate
        TxSamplingRate
        % Tx LPF
        TxBandwidth
        TxFilterOrder
        TxFilterShape
        TxFilterDomain
        % Channel
        SNR
        % Rx LPF
        RxBandwidth
        RxFilterOrder
        RxFilterShape
        RxFilterDomain
        % Sampler
        RxSamplingRate
        SamplingPhase
        % ADC
        ADCResolution
        % DeOverlap
    end
    properties (SetAccess = private)
        DAC
        Rectpulse
        LPFTx
        Channel
        LPFRx
        Sampler
        ADC
        DeO
    end
    
    methods
        %%
        function obj = ChannelEleAWGN(varargin)
            SetVariousProp(obj, varargin{:})
        end
        %%
        function Processing(obj)
            obj.Count = obj.Count + 1;
            Init(obj);
            
            %
            obj.DAC.Input = obj.Input;
            obj.DAC.Processing();
            
            %
            obj.Rectpulse.Input = obj.DAC.Output;
            obj.Rectpulse.Processing();
            
            %
            obj.LPFTx.Input = obj.Rectpulse.Output;
            obj.LPFTx.Processing();
            
            % transmit signal through channel
            obj.Channel.Input = obj.LPFTx.Output;
            obj.Channel.Processing();
            
            %
            obj.LPFRx.Input = obj.Channel.Output;
            obj.LPFRx.Processing();
            
            %
            obj.Sampler.Input = obj.LPFRx.Output;
            obj.Sampler.Processing();
            
            %
            obj.DAC.Input = obj.Sampler.Output;
            obj.DAC.Processing();
            
            % De-overlap
            obj.DeO.Input = obj.DAC.Output;
            obj.DeO.Processing();
            
            % 
            obj.Output = obj.DeO.Output;
        end
        %%
        function Init(obj)
            if obj.Count == 1
                obj.DAC         = EleQuantizer('Resolution', obj.DACResolution);
                obj.Rectpulse   = EleRectPulse('SymbolRate', obj.SymbolRate,...
                                            'SamplingRate', obj.TxSamplingRate);
                obj.LPFTx       = EleLPF('Bandwidth', obj.TxBandwidth,...
                                        'FilterOrder', obj.TxFilterOrder,...
                                        'FilterShape', obj.TxFilterShape,...
                                        'FilterDomain', obj.TxFilterDomain);
                obj.Channel     = ChEleAWGN('FrameOverlapRatio', obj.FrameOverlapRatio,...
                                            'SNR', obj.SNR);
                obj.LPFRx       = EleLPF('Bandwidth', obj.RxBandwidth,...
                                        'FilterOrder', obj.RxFilterOrder,...
                                        'FilterShape', obj.RxFilterShape,...
                                        'FilterDomain', obj.RxFilterDomain);
                obj.Sampler     = EleSampler('SamplingRate', obj.RxSamplingRate,...
                                            'SamplingPhase', obj.SamplingPhase);
                obj.ADC         = EleQuantizer('Resolution', obj.ADCResolution);
                obj.DeO         = DeOverlap('FrameOverlapRatio', obj.FrameOverlapRatio);
            end
        end
        %%
        function Reset(obj)
            obj.DeO.Reset;
        end
    end
end