function result = gaussian(v, sig)
% GAUSSIAN
%   GAUSSIAN(v, sig) takes in a vector of real numbers, v, and a width
%   parameter, sig, and applies a Gaussian function to each coordinate,
%   with the peak centered at 0 and of height 1

    result = exp(-v.^2/(2*sig^2));
end