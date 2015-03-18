function [ ] = KCCA_SimilarityMap( currentFolder,No, coordinate, CTfeatureT,MRIfeatureT)
% KCCA_SimilarityMap aims to evaluate the CTfeatureT and MRIfeatureT, will
% generate a color code map of similarity. 
% INPUT:  currentFolder             -FOLDER for work space.
%         No                        -index of subject.
%         coordinate                -point chosen in one image
%                                    (Template image). The corresponding
%                                    point will be found in another
%                                    image(subject image).
%         CTfeatureT, MRIfeatureT   -The feature of CT and MR images.

% example coordinate = [37 29 21];[13 29 5][37 75 21] [12 51 5][56 54 5][8 60 5]

dir_input = currentFolder;
infoCT = analyze75info([dir_input '/Test/feature/p' num2str(No) '/ct_crop8060_p'  num2str(No) '.hdr']);
dataCT = double(analyze75read(infoCT));
infoMRI = analyze75info([dir_input '/Test/feature/p' num2str(No) '/mr_elstx_crop8060_p'  num2str(No) '.hdr']);
dataMRI = double(analyze75read(infoMRI));

i = coordinate(3);
rt = 6400; 
CT_CCAfeature =  CTfeatureT((i-1)*rt+1:i*rt,:);  
MRI_CCAfeature = MRIfeatureT((i-1)*rt+1:i*rt,:); 

[crdnt,rt,ct,vt] = coordinateTransform(dataMRI, coordinate);

similarity.corr{1} = NCC(MRI_CCAfeature,CT_CCAfeature(crdnt,:));
similarity.corr{1} = reshape(similarity.corr{1},rt,ct);

%% ---------------------------------------------------------------------------------------------

figure
   subplot(221)
   
   colormap gray
   imagesc(dataCT(:,:,coordinate(3)));
   freezeColors
   set(gca,'xtick',[],'ytick',[]);
   get(gca, 'Position');
   title('CT' );
   hold on
   plot(coordinate(2),coordinate(1),'+y')  % bound
   hold off
   
   subplot(222)
   
   colormap gray
   imagesc(dataMRI(:,:,coordinate(3)));
   freezeColors
   set(gca,'xtick',[],'ytick',[]);
   get(gca, 'Position');
   title('MRI' );
   hold on
   plot(coordinate(2),coordinate(1),'+y')  % bound
   hold off
   
   subplot(223)
   
   colormap jet
   imagesc((normalize(similarity.corr{1})));
   freezeColors
   set(gca,'xtick',[],'ytick',[]);
   get(gca, 'Position');
   title('Similarity Map' );
    colorbar
   hold on
   plot(coordinate(2),coordinate(1),'+y')  % bound
   hold off
end

function n = normalize(ori)
n = (ori - min(ori(:)))/(max(ori(:)) - min(ori(:)));
end
function [crdnt,rt,ct,vt]=coordinateTransform(data, coordinate)

[rt,ct,vt] = size(data);
xt = coordinate(1);
yt = coordinate(2);


crdnt = xt+(yt-1)*rt;
end 

