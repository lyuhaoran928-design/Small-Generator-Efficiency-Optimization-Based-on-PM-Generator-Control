function cv1 = costF(x)
        set_param('test/R', 'Resistance', num2str(x(1)));
        WW = sim('test');
        RR1 = WW.ScopeData1.signals.values;
        cv1 = max(RR1);
        if isempty(cv1) || isnan(cv1) || isinf(cv1)
            cv1 = 0;  
        end

        disp(['本批次成本:', num2str(cv1)]);

end
