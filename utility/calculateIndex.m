function [ x,y,z ] = calculateIndex( x,y,z )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
x1 = x-55;
x2 = x1-1+193;
y1 = y-32;
y2 = y1-1+153;
z1 = z-2;
z2 = z1+2 +60-1+2;
x = [x1,x2];
y = [y1,y2];
z = [z1,z2];
end

