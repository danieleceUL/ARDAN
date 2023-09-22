function [croppedMask, img]=customROIMask(img, roi)
% Custom Region-of-Interest (ROI) Mask function masks and crops part of the
% image in which slanted edges are to be found
%
% Input:
%    img:       The Image (grayscale).
%    roi:       Region-of-Interest mask 
%
% Output:
%    croppedMask: The cropped mask (Uint8)
%    img        : Masked Image
%

% Author: D. Jakab 2023, University of Limerick

%--------------------------------------------------------------------------
    mask = createMask(roi, img);
    %imshow(mask)
    uInt8ImageMask = uint8(255 * mask);
    maskedImage = img .* cast(mask, class(img));
    column1 = find(sum(mask, 1), 1, 'first');
    column2 = find(sum(mask, 1), 1, 'last');
    row1 = find(sum(mask, 2), 1, 'first');
    row2 = find(sum(mask, 2), 1, 'last');
    croppedMask = uInt8ImageMask(row1:row2, column1:column2);
    img = maskedImage(row1:row2, column1:column2);
end