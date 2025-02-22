function visualizeKDE(varargin)

decompose = 1 ;
draw_to_these_axes = [] ;
useEdgeColorBlack = 1 ;
deactivateFaceColor = 0 ;
useAlphaWeights = 1 ;
color = 'r' ;
grans = 100 ;
kde = [] ;
data = [] ;
showdata = [] ;
tabulated = 0 ;
edgeWidth = 2;
% process arguments
args = varargin;
nargs = length(args);
for i = 1:2:nargs
    switch args{i}        
        case 'kde', kde = args{i+1} ;
        case 'data', data = args{i+1} ;          
        case 'showdata', showdata = args{i+1} ;       
        case 'tabulated', tabulated = args{i+1} ;
        case 'grans', grans = args{i+1} ;
        case 'showkdecolor', color = args{i+1} ;
        case 'useAlphaWeights', useAlphaWeights = args{i+1} ;
        case 'deactivateFaceColor', deactivateFaceColor = args{i+1} ;
        case 'useEdgeColorBlack', useEdgeColorBlack = args{i+1}   ;         
        case 'draw_to_these_axes', draw_to_these_axes = args{i+1}   ;   
        case 'decompose', decompose = args{i+1}   ;
        case 'edgewidth', edgeWidth = args{i+1};
    end
end

if isempty(draw_to_these_axes)
    draw_to_these_axes = gca ;
end

showTabulated = 1 ;
if size(kde.pdf.Mu,1) ~= 2 || tabulated == 0
    showTabulated = 0 ;    
end   

if showTabulated ~= 1
    drawDistributionGMM( 'pdf',kde.pdf, 'color', color, 'decompose', decompose, ...
           'useAlphaWeights', useAlphaWeights, 'deactivateFaceColor', deactivateFaceColor, ...
           'useEdgeColorBlack', useEdgeColorBlack, 'draw_to_these_axes', draw_to_these_axes, ...
           'edgewidth',edgeWidth) ;            
else
    %hold off ; plot(kde.pdf.Mu(1,1),kde.pdf.Mu(2,1),'*'); 
    hold off ;
    drawDistributionGMM( 'pdf',kde.pdf, 'color', [1 1 1], 'draw_to_these_axes', draw_to_these_axes, ...
        'edgewidth',edgeWidth) ;
    boundsIm = axis ; hold off ;    
%     visualizePdf2d2( kde.pdf, boundsIm, [], grans, draw_to_these_axes ) ;  
    [A, ~, X_tck, Y_tck] = tabulate2D_gmm( kde.pdf, boundsIm, grans ) ; 
    set(draw_to_these_axes,'NextPlot','add') ;
    imagesc(X_tck, Y_tck, A) ;

%     set(draw_to_these_axes,'XTickLabel',{}); set(draw_to_these_axes,'YTickLabel',{}) ;
    axis equal ; axis tight  ; title('Estimated') ;
end

h = ishold ;
if ~isempty(data) && showdata == 1
    hold on ;
    if size(kde.pdf.Mu,1) == 1
        plot(draw_to_these_axes, obsAll(1,:),obsAll(1,:)*0,'.r') ;
    elseif size(kde.pdf.Mu,1) == 2
        plot(draw_to_these_axes, obsAll(1,:),obsAll(2,:),'.r') ;
    elseif size(kde.pdf.Mu,1) == 3
        plot3(draw_to_these_axes, obsAll(1,:),obsAll(2,:),obsAll(3,:),'.r') ;
    end
    if ( h == 0 ) hold off ; end
end