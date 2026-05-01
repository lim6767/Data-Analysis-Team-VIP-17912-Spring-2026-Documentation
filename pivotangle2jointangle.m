function phi = pivotangle2jointangle(theta, L1, L2)
%
% Inputs:
% theta = radial angle of pivot (0 degrees is the axis from center of cycling wheel to hip)
% L1 = length of upper leg (quad)
% L2 = length of lower leg
%
% Output:
% phi = joint angle of leg
%
% NOTE TO USERS: The measurements for variable "r", "d", "L1", and "L2"
% must be done carefully. Otherwise, the program will output different
% angles than your empirical joint angles. This is a problem you cannot 
% avoid. You just have to estimate where the axes of your knee and your hip
% are and compare the angles from this function to your observed angles.

% cycle radius
r = 5;
% distance from center of wheel to hip
d = 28;

p_squared = r^2 + d^2 - 2*r*d.*cosd(theta);

k = (L1^2 + L2^2 - p_squared) ./ (2*L1*L2);

phi = 180 - acosd(k);

end