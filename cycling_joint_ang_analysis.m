%% Recording and Comparing Cycling Data
%
% Description: This code is very similar to the code to find joint angles,
% but this is exclusively recording data while cycling.
% Here, a total of THREE IMUs are being involved. One for upper and lower
% leg, and one that should be attached to the central pivot of the cycling
% wheel.
%
%
%% DATA LOADING & PRE-PROCESSING
% Load your Xsens Dot IMU quaternion data here:
IMU_A = readtable("yoneA4.csv"); % upper part of the leg
IMU_B = readtable("yoneB4.csv"); % lower part of the leg
pivotIMU = readtable("Lim4.csv"); % the IMU on the center of the cycling wheel

% normalizing time
IMU_A(:, 2) = (IMU_A(:, 2) - IMU_A(1,2)) ./ 1000000;
IMU_B(:, 2) = (IMU_B(:, 2) - IMU_B(1,2)) ./ 1000000;
pivotIMU(:,2) = (pivotIMU(:,2) - pivotIMU(:,2)) ./ 1000000; 

time1 = IMU_A{:,2};

% Create and normalize quaternions
%
% Functions:
% "quaternion(IMU)": function takes quaternion data [qw, qx, qy, qz] from
% IMU and converts it into actual quaternion objects
%
% "normalize(quaternions)": normalizes the entries of the quaterions (so 
% that it represents pure rotation and no scaling.
%
qA = normalize(quaternion(IMU_A{:,3:6}));
qB = normalize(quaternion(IMU_B{:,3:6}));
pivotquat = normalize(quaternion(pivotIMU{:,3:6}));

% Ensure same length (so that there is no issue in plotting
len1 = min([size(qA,1), size(pivotquat, 1), size(qB, 1)]);
qA = qA(1:len1); 
qB = qB(1:len1); 
time1 = time1(1:len1);

%% IMPORTANT
% Choose the time interval you want to plot and observe (this can be made
% into a user input function, if you want)
%
% Example: 
% Select indices corresponding to the time range between 1 and 53 seconds:
timeRangeIndices = time1 >= 1 & time1 <= 53;
qA = qA(timeRangeIndices);
qB = qB(timeRangeIndices);
time1 = time1(timeRangeIndices);

%% Calculating Joint Angle via Dot Product

% Define the "bone axis" in the local sensor frame (usually in the
% x-direction):
boneDir = [1, 0, 0];

% For every step, compute how much the bone-axis vector rotates for each
% IMU. This finds where the "bone" is pointing in the room for every frame.
%
% Functions:
% "rotatepoint(qA, boneDir)": rotates the vector boneDir in the orientation
% of the quaternion, qA.
%
vA = rotatepoint(qA, boneDir);
vB = rotatepoint(qB, boneDir);

% perform dot product (you know this, I hope)
%
dot1 = dot(vA, vB, 2);
dot1 = max(min(dot1, 1), -1); % numerical stability clipping
rawAngle1 = acosd(dot1);

% making output angle range from [-180,180] to [0,360]
finalAngle1 = wrapTo360(rawAngle1);

%% PLOTTING
subplot(2,2,1)
plot(time1, finalAngle1, 'r', 'LineWidth', 1.5);
title("Joint Angles of Leg during Cycling");
xlabel('Time (s)');
ylabel('Angle (deg)');
grid on;

%% Pivot Angle and applying forward kinematics
% getting quaternions from pivot IMU based on chosen time interval
pivotquat = pivotquat(timeRangeIndices);

% computing euler angles for each frame
euler_angles = eulerd(pivotquat, "ZYX", "point");

% retrieve the Z-rotation (first column), because the IMU on the pivot is 
% rotating about the z-axis through the cycling motion.
angles = euler_angles(:,1);

angles_wrapped = wrapTo360(angles);

% retrieve predicted angles from UDF pivotangle2jointangle
predictedAngles = pivotangle2jointangle(angles_wrapped, 16,18);

% plotting predictedAngles
subplot(2,2,2)
plot(time1, predictedAngles, 'r', 'LineWidth', 1.5);
title("Predicted Joint Angles during Cycling");
xlabel('Time (s)');
ylabel('Predicted Angle (deg)');
grid on;

%% Comparing empirical data with predicted data (error analysis)
% Calculate the error between final angles and predicted angles
angleError = finalAngle1 - predictedAngles;
meanError = mean(angleError);
disp(['Mean Angle Error: ', num2str(meanError)]);
stdError = std(angleError);
disp(['Standard Deviation of Angle Error: ', num2str(stdError)]);

% Calculate the root mean square error (RMSE) for a more robust error analysis
rmseError = sqrt(mean(angleError.^2));
disp(['Root Mean Square Error: ', num2str(rmseError)]);

% error plot
subplot(2,2,[3,4]);
plot(time1, angleError, 'k', 'LineWidth', 1.5);
title("Angle Error between Empirical and Predicted Angles");
xlabel('Time (s)');
ylabel('Angle Error (deg)');
grid on;