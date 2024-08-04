function addToPythonPath(varargin)
% function accepts a single input of path, e.g. 'C:\MPS\Code\' or if no 
% inputs passed to the function then it adds the path of where this file 
% resides to the Python path

% if no path specified, use path of this file
if nargin == 0
    % assumes the .py code is in the same directory as this file 
    % assumes only a single file exists with this name on deployed MATLAB path
    myPath = fileparts(which(mfilename));
elseif nargin == 1
    myPath = varargin{1};
else
    error('Too many inputs');
end

% add to Python path
if count(py.sys.path, myPath) == 0
    insert(py.sys.path,int32(0), myPath)
end
disp(myPath)
