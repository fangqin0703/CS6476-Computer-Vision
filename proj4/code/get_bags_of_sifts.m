    % Starter code prepared by James Hays for Computer Vision

%This feature representation is described in the handout, lecture
%materials, and Szeliski chapter 14.

function image_feats = get_bags_of_sifts(image_paths)
% image_paths is an N x 1 cell array of strings where each string is an
% image path on the file system.

% This function assumes that 'vocab.mat' exists and contains an N x 128
% matrix 'vocab' where each row is a kmeans centroid or visual word. This
% matrix is saved to disk rather than passed in a parameter to avoid
% recomputing the vocabulary every run.

% image_feats is an N x d matrix, where d is the dimensionality of the
% feature representation. In this case, d will equal the number of clusters
% or equivalently the number of entries in each image's histogram
% ('vocab_size') below.

% You will want to construct SIFT features here in the same way you
% did in build_vocabulary.m (except for possibly changing the sampling
% rate) and then assign each local feature to its nearest cluster center
% and build a histogram indicating how many times each cluster was used.
% Don't forget to normalize the histogram, or else a larger image with more
% SIFT features will look very different from a smaller version of the same
% image.

%{
Useful functions:
[locations, SIFT_features] = vl_dsift(img) 
 http://www.vlfeat.org/matlab/vl_dsift.html
 locations is a 2 x n list list of locations, which can be used for extra
  credit if you are constructing a "spatial pyramid".
 SIFT_features is a 128 x N matrix of SIFT features
  note: there are step, bin size, and smoothing parameters you can
  manipulate for vl_dsift(). We recommend debugging with the 'fast'
  parameter. This approximate version of SIFT is about 20 times faster to
  compute. Also, be sure not to use the default value of step size. It will
  be very slow and you'll see relatively little performance gain from
  extremely dense sampling. You are welcome to use your own SIFT feature
  code! It will probably be slower, though.

D = vl_alldist2(X,Y) 
   http://www.vlfeat.org/matlab/vl_alldist2.html
    returns the pairwise distance matrix D of the columns of X and Y. 
    D(i,j) = sum (X(:,i) - Y(:,j)).^2
    Note that vl_feat represents points as columns vs this code (and Matlab
    in general) represents points as rows. So you probably want to use the
    transpose operator '  You can use this to figure out the closest
    cluster center for every SIFT feature. You could easily code this
    yourself, but vl_alldist2 tends to be much faster.

Or:

For speed, you might want to play with a KD-tree algorithm (we found it
reduced computation time modestly.) vl_feat includes functions for building
and using KD-trees.
 http://www.vlfeat.org/matlab/vl_kdtreebuild.html

%}

load('vocab_200.mat')
%load('vocab_100.mat')
vocab_size = size(vocab, 2);
 
N = size(image_paths);
%image_feats = zeros(N, vocab_size);
image_feats = [];
 
for i = 1:N
    image = imread(image_paths{i});
    img = single(image);
%     img = imgaussfilt(img, 2);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%impyramid method%%%%%%%%%%%%%%%%%%%%%%%%%
%     I1 = impyramid(img, 'reduce');
%     [~, sift_feats] = vl_dsift(I1, 'fast', 'step', 5);
%     I2 = impyramid(I1, 'reduce');
%     [~, sift_feats] = vl_dsift(I2, 'fast', 'step', 5);
%     I3 = impyramid(img, 'expand');
%     [~, sift_feats] = vl_dsift(I3, 'fast', 'step', 5);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %%%%%%%%%%%%%%%downsample using factors of 0.9%%%%%%%%%%%%%%%%%%%%%%%
%     I1 = imresize(img, 0.9);
%     [~, sift_feats] = vl_dsift(I1, 'fast', 'step', 5);
%     I2 = imresize(img, 0.81);
%     [~, sift_feats] = vl_dsift(I2, 'fast', 'step', 5);
%     I3 = imresize(img, 1.11);
%     img = imgaussfilt(I3, 2);
%     [~, sift_feats] = vl_dsift(img, 'fast', 'step', 5);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    [~, sift_feats] = vl_dsift(img, 'fast', 'step', 5);
    sift_feats=single(sift_feats);

    all_dist = vl_alldist2(sift_feats, vocab);
    %all_dist = all_dist';

    [~, index] = min(all_dist');
    
    bins=1:vocab_size;
    histogram=histc(index,bins);
    histogram=histogram./norm(histogram);
    image_feats(i,:) = histogram;

end