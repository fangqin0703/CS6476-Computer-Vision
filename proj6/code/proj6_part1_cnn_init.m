function net = proj6_part1_cnn_init()
%code for Computer Vision, Georgia Tech by James Hays
%based of the MNIST example from MatConvNet

rng('default');
rng(0);

% constant scalar for the random initial network weights. You shouldn't
% need to modify this.
f=1/100; 

net.layers = {} ;

%conv original
net.layers{end+1} = struct('type', 'conv', ...
                           'weights', {{f*randn(9,9,1,10, 'single'), zeros(1, 10, 'single')}}, ...
                           'stride', 1, ...
                           'pad', 0, ...
                           'name', 'conv1') ;
                       

%max-pool and relu original
net.layers{end+1} = struct('type', 'pool', ...
                           'method', 'max', ...
                           'pool', [7 7], ...
                           'stride', 3, ...
                           'pad', 0) ;

net.layers{end+1} = struct('type', 'relu') ;

% insert layer for deeper network
net.layers{end+1} = struct('type', 'conv', ...
                           'weights', {{f*randn(5,5,1,10, 'single'), zeros(1, 10, 'single')}}, ...
                           'stride', 1, ...
                           'pad', 0, ...
                           'name', 'conv1') ;
                       
net.layers{end+1} = struct('type', 'pool', ...
                           'method', 'max', ...
                           'pool', [3 3], ...
                           'stride', 2, ... %% can;t chage here
                           'pad', 0) ;
                       
%net.layers{end+1} = struct('type', 'relu') ;
% Insert dropout layer
net.layers{end+1} = struct('type','dropout','rate',0.3); 
                   
% adjust final layer
net.layers{end+1} = struct('type', 'conv', ...
                           'weights', {{f*randn(6,6,10,15, 'single'), zeros(1, 15, 'single')}}, ...
                           'stride', 1, ...
                           'pad', 0, ...
                           'name', 'fc1') ;
                       
% Loss layer
net.layers{end+1} = struct('type', 'softmaxloss') ;

net = vl_simplenn_tidy(net);

% %You can insert batch normalization layers here
% net = insertBnorm(net, 1)

% Visualize the network
vl_simplenn_display(net, 'inputSize', [64 64 1 50])


% --------------------------------------------------------------------
function net = insertBnorm(net, layer_index)
% --------------------------------------------------------------------
assert(isfield(net.layers{layer_index}, 'weights'));
ndim = size(net.layers{layer_index}.weights{1}, 4);
layer = struct('type', 'bnorm', ...
               'weights', {{ones(ndim, 1, 'single'), zeros(ndim, 1, 'single')}}, ...
               'learningRate', [1 1 0.05]) ;
net.layers{layer_index}.weights{2} = [] ;  % eliminate bias in previous conv layer
net.layers = horzcat(net.layers(1:layer_index), layer, net.layers(layer_index+1:end)) ;



