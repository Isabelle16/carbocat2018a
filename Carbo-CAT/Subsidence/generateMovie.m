function subs = generateMovie(subs)

theMovie = VideoWriter('theMovieSubs.avi');
theMovie.FrameRate = 1;

open(theMovie);


% ScreenSize is a four-element vector: [left, bottom, width, height]:
scrsz = get(0,'ScreenSize'); % vector
% position requires left bottom width height values. screensize vector
% is in this format 1=left 2=bottom 3=width 4=height


subs.figure7 = figure('Visible','off','Position',[5 5 scrsz(3)*0.5 scrsz(4)*0.5]);
set(gca,'nextplot','replacechildren');
set(gcf,'Renderer','zbuffer');

plotFigure7(subs);

function plotFigure7(subs)
        
        cmin=min(subs.subsidence(:));
        cmax=max(subs.subsidence(:));
        figure(subs.figure7);
        %load('colorMaps/colorMapCA7Facies','CA7FaciesCMap');
        %set(glob.figure7,'Colormap',CA7FaciesCMap);
        
        
        
        for t=1:subs.maxT
            
            %clf
            %Draw an invisible line that will scale the figure as time steps
            %forward
            surf(subs.subsidence(:,:,t))
            colorbar
            %caxis([cmin cmax])
            view(0,90);
            frame = getframe(gcf);
            writeVideo(theMovie,frame);
            
        end
        
    end

close(theMovie);

end