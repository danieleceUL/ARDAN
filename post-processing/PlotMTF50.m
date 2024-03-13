function mtf50data = PlotMTF50(fn)
    % PlotMTF50 - plot 50% of the Modulation Transfer Function (MTF) and mark clearly with a legend
    % MTF50 is a typical measure of image quality.
    %
    % Input:
    %    fn:       filename of matlab figure from which MTF plots can be found
    %
    % Output:
    %    mtf50data:Extracted MTF50 data from any MTF plot.

    % Created by D. Jakab 2024, University of Limerick

    h = findobj(gca,'Type','line');
    h
    lgd = findobj(gcf,'Type','legend');
    fontsize(lgd,10,'points')
    grid on;
    ylabel('SFR/MTF')
    x=get(h(1:size(h,1)),'Xdata');
    y=get(h(1:size(h,1)),'Ydata');
    mtf50data = cell(size(h,1), 2);
    mtf50data{size(h,1), 2} = [];
    size(mtf50data)
    x
    y

    for i = 1:size(y,1)
        x_i = x(i);
        x_i = x{i};
        y_i = y(i);
        y_i = y{i};
        size(y_i, 2)
        if (isnan(any(x_i))) || (any(isnan(y_i))) || (size(x_i, 2) < 101) || (size(y_i, 2) < 101)
            mtf50data{i, 1} = 'None';
            mtf50data{i, 2} = 0;
            continue;
        else
            mtf50XValue = interp1(y_i(1:50), x_i(1:50), 0.5)
            n = get(h(i), 'DisplayName')
                switch n
                    case 'edge'
                        c = 'r';
                    case 'middle'
                        c = 'b';
                    case 'centre'
                        c = 'g';
                    case 'Vertical'
                        c = [0.8500 0.3250 0.0980];
                    case 'Horizontal'
                        c = [0 0.4470 0.7410];
                end
            if (~contains(fn,'all'))
                plot(mtf50XValue, 0.5, '*', 'Color', c, 'DisplayName', ['MTF50: ' num2str(mtf50XValue)])
            end
            mtf50data{i, 1} = n;
            mtf50data{i, 2} = mtf50XValue;
        end
    end
end