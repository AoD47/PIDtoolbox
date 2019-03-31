%% PTtuningParams - scripts for plotting tune-related parameters

% ----------------------------------------------------------------------------------
% "THE BEER-WARE LICENSE" (Revision 42):
% <brian.white@queensu.ca> wrote this file. As long as you retain this notice you
% can do whatever you want with this stuff. If we meet some day, and you think
% this stuff is worth it, you can buy me a beer in return. -Brian White
% ----------------------------------------------------------------------------------


if ~isempty(filenameA) || ~isempty(filenameB)
    
PTtunefig=figure(4);
prop_max_screen=(max([PTtunefig.Position(3) PTtunefig.Position(4)]));
fontsz4=round(screensz_multiplier*prop_max_screen);



guiHandlesTune.saveFig4.FontSize=fontsz4;
guiHandlesTune.refresh4.FontSize=fontsz4;
guiHandlesSpec.checkboxrateHigh.FontSize=fontsz4;

%% step resp computed directly from set point and gyro

ylab={'R';'P';'Y'};
ylab2={'roll';'pitch';'yaw'};
    %%%%%%%%%%%%% step resp A %%%%%%%%%%%%%
if ~isempty(filenameA)    
    for p=1:3         
        try
            if ~updateStep            
                [stepresp_A{p} tA rateHigh_A{p}] = PTstepcalc(DATtmpA.RCRate(p,:), DATtmpA.GyroFilt(p,:), A_lograte); 
            end
        catch
            stepresp_A{p}=[];
            rateHigh_A{p}=[];
        end
        h1=subplot('position',posInfo.TparamsPos(p,:)); cla
        hold on
        if guiHandlesSpec.checkboxrateHigh.Value==1, 
            rA=find(rateHigh_A{p}==1);
        else
            rA=find(rateHigh_A{p}==0);
        end
             
        if ~isempty(rA)
            m=nanmean(stepresp_A{p}(rA,:));
            sd=std(stepresp_A{p}(rA,:));%/sqrt(size(stepresp_A,1));
            h1=plot(tA,m);         set(h1, 'color',[colorA],'linewidth',2)
            h2=plot(tA,m-sd,'--'); set(h2, 'color',[colorA],'linewidth',.5) 
            h3=plot(tA,m+sd,'--'); set(h3, 'color',[colorA],'linewidth',.5)
            stepnfo=stepinfo(nanmean(stepresp_A{p}(rA,:)),tA,1);
            
            eval(['PIDF=' ylab2{p} 'PIDF_A;'])
            h=text(320, .8, ['N=' int2str(size(stepresp_A{p}(rA,:),1)) ]);set(h,'fontsize',fontsz4)
            h=text(320, .7, ['PIDF: ' char(string(PIDF(:,2)))]);set(h,'fontsize',fontsz4) 
            h=text(320, .6, ['Peak: ' num2str(stepnfo.Peak)]);set(h,'fontsize',fontsz4)
            h=text(320, .5, ['PeakTime: ' num2str(stepnfo.PeakTime)]);set(h,'fontsize',fontsz4) 
            h=text(320, .4, ['%Overshoot: ' num2str(stepnfo.Overshoot)]);set(h,'fontsize',fontsz4) 
            h=text(320, .3, ['RiseTime: ' num2str(stepnfo.RiseTime)]);set(h,'fontsize',fontsz4)
            h=text(320, .2, ['SettlingMin: ' num2str(stepnfo.SettlingMin)]);set(h,'fontsize',fontsz4) 
            h=text(320, .1, ['SettlingMax: ' num2str(stepnfo.SettlingMax)]);set(h,'fontsize',fontsz4) 
        else
            h=text(180, 1.1, ['insufficient data'])
            set(h,'fontsize',fontsz4,'fontweight','bold')
        end
        
        if p==3
            set(gca,'fontsize',fontsz4,'xminortick','on','yminortick','on','xtick',[0 100 200 300 400 500],'xticklabel',{'0' '100' '200' '300' '400' '500'},'ytick',[0 .2 .4 .6 .8 1 1.2 1.4 1.6],'tickdir','out')
        else
            set(gca,'fontsize',fontsz4,'xminortick','on','yminortick','on','xtick',[0 100 200 300 400 500],'xticklabel',{'' '' '' '' '' ''},'ytick',[0 .2 .4 .6 .8 1 1.2 1.4 1.6],'tickdir','out')
        end
        box off
        h=ylabel({'mean response (+/-sd)'}, 'fontweight','bold');
        set(h,'fontsize',fontsz4)
        if p==3, xlabel('time (ms)', 'fontweight','bold');end
        if p==1, title('Step response [A]');end
        h=text(5,1.5,ylab2{p});
        set(h,'fontsize',fontsz4,'fontweight','bold')
         h=plot([0 500],[1 1],'k--');
        set(h,'linewidth',.5)
        axis([0 500 0 1.6])
    end
end

     %%%%%%%%%%%%% step resp B %%%%%%%%%%%%%
if ~isempty(filenameB)
    for p=1:3  
        try
            if ~updateStep            
                [stepresp_B{p} tB rateHigh_B{p}] = PTstepcalc(DATtmpB.RCRate(p,:), DATtmpB.GyroFilt(p,:), B_lograte);
            end
        catch
            stepresp_B{p}=[];
            rateHigh_B{p}=[];
        end
       h1=subplot('position',posInfo.TparamsPos(p+3,:)); cla 
       hold on
       if guiHandlesSpec.checkboxrateHigh.Value==1, 
            rB=find(rateHigh_B{p}==1);
        else
            rB=find(rateHigh_B{p}==0);
        end
        if ~isempty(rB)
            m=nanmean(stepresp_B{p}(rB,:));
            sd=std(stepresp_B{p}(rB,:));%/sqrt(size(stepresp_B,1));
            h4=plot(tB,m);         set(h4, 'color',[colorB],'linewidth',2)
            h5=plot(tB,m-sd,'--'); set(h5, 'color',[colorB],'linewidth',.5)
            h6=plot(tB,m+sd,'--'); set(h6, 'color',[colorB],'linewidth',.5)
            stepnfo=stepinfo(nanmean(stepresp_B{p}(rB,:)),tB,1);   
            
            eval(['PIDF=' ylab2{p} 'PIDF_B;'])
            h=text(320, .8, ['N=' int2str(size(stepresp_B{p}(rB,:),1)) ]);set(h,'fontsize',fontsz4)
            h=text(320, .7, ['PIDF: ' char(string(PIDF(:,2)))]);set(h,'fontsize',fontsz4)
            h=text(320, .6, ['Peak: ' num2str(stepnfo.Peak)]);set(h,'fontsize',fontsz4)
            h=text(320, .5, ['PeakTime: ' num2str(stepnfo.PeakTime)]);set(h,'fontsize',fontsz4) 
            h=text(320, .4, ['%Overshoot: ' num2str(stepnfo.Overshoot)]);set(h,'fontsize',fontsz4) 
            h=text(320, .3, ['RiseTime: ' num2str(stepnfo.RiseTime)]);set(h,'fontsize',fontsz4)
            h=text(320, .2, ['SettlingMin: ' num2str(stepnfo.SettlingMin)]);set(h,'fontsize',fontsz4) 
            h=text(320, .1, ['SettlingMax: ' num2str(stepnfo.SettlingMax)]);set(h,'fontsize',fontsz4) 
        else
            h=text(180, 1.1, ['insufficient data'])
            set(h,'fontsize',fontsz4,'fontweight','bold')
        end 
        
        if p==3
            set(gca,'fontsize',fontsz4,'xminortick','on','yminortick','on','xtick',[0 100 200 300 400 500],'xticklabel',{'0' '100' '200' '300' '400' '500'},'ytick',[0 .2 .4 .6 .8 1 1.2 1.4 1.6],'tickdir','out')
        else
            set(gca,'fontsize',fontsz4,'xminortick','on','yminortick','on','xtick',[0 100 200 300 400 500],'xticklabel',{'' '' '' '' '' ''},'ytick',[0 .2 .4 .6 .8 1 1.2 1.4 1.6],'tickdir','out')
        end
        
        box off
        h=ylabel({'mean response (+/-sd)'}, 'fontweight','bold');
        set(h,'fontsize',fontsz4)
        if p==3, xlabel('time (ms)', 'fontweight','bold');end
        if p==1, title('Step response [B]');end
        h=text(5,1.5,ylab2{p});
        set(h,'fontsize',fontsz4,'fontweight','bold')
        h=plot([0 500],[1 1],'k--');
        set(h,'linewidth',.5)
        axis([0 500 0 1.6])
    end
end

updateStep=0;

end

