function [absolutepath] = createabsolutepath(path)
%CREATEABSOLUTEPATH creates an absolute path independent if the argument is
%relative or absolute

if strcmp(path(1), '.')
    absolutepath = fullfile(pwd, path);
else
    absolutepath = fullfile(path);
end 

end