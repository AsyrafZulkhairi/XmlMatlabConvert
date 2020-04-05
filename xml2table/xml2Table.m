%This script read bounding box value from xml of dataset label and build a table for MATLAB cascade training.
%Require xml2struct.m in current path.
%by Asyraf Zulkhairi
ObjectName = 'car'; %change this depends on object name

xmlFiles = dir('*.xml');
numfiles = length(xmlFiles);
fprintf('Number of xml is %d\n',numfiles);
f=0;
for j = 1:numfiles
    data = xml2struct(xmlFiles(j).name);
    if ~(isfield(data.annotation,'object'))
        fprintf('%s --> doesnt have label, the xml is ignored\n',xmlFiles(j).name);
        continue;
    end
    f=f+1;
end
fprintf('Will process %d xml\n',f);
fprintf('Press any key to continue\n');
pause();
imageFilename = cell(f,1); %declare a fx1 cell array
Car = cell(f,1); %declare a fx1 cell array
if ~exist('label', 'dir') %If output folder doesn't exist
    mkdir label; %Create output folder in current directory
end
f=1;
for j = 1:numfiles
    data = xml2struct(xmlFiles(j).name);
    if ~(isfield(data.annotation,'object'))
        continue;
    end
    
    %Copy xml and jpg with label only to folder "label" (to get rid of xml
    %without jpg)
    if isfile(data.annotation.filename.Text)
        fprintf('%s\n',xmlFiles(j).name);
        copyfile(xmlFiles(j).name, "label");
        copyfile(data.annotation.filename.Text, "label");
    else
        fprintf('%s --> no associated image file found\n',xmlFiles(j).name);
        imageFilename(j) = [];
        Car(j) = [];
        continue
    end

    imageFilename{f} = fullfile(pwd, data.annotation.filename.Text);
    len = length(data.annotation.object);
    if len == 1
        a = data.annotation.object.bndbox.xmin;
        a = str2double(cell2mat(struct2cell(a)));
        x = a;
        a = data.annotation.object.bndbox.ymin;
        a = str2double(cell2mat(struct2cell(a)));
        y = a;
        a = data.annotation.object.bndbox.xmax;
        a = str2double(cell2mat(struct2cell(a)));
        w = a-(x-1);
        a = data.annotation.object.bndbox.ymax;
        a = str2double(cell2mat(struct2cell(a)));
        h = a-(y-1);
        if strcmp(cell2mat(struct2cell(data.annotation.object.name)),ObjectName)
            temp = Car{f};
            temp(1,:) = [x,y,w,h];
            Car{f} = temp;
        end
    else
        k = 1;
        for i = 1:len
            a = data.annotation.object{1,i}.bndbox.xmin;
            a = str2double(cell2mat(struct2cell(a)));
            x = a;
            a = data.annotation.object{1,i}.bndbox.ymin;
            a = str2double(cell2mat(struct2cell(a)));
            y = a;
            a = data.annotation.object{1,i}.bndbox.xmax;
            a = str2double(cell2mat(struct2cell(a)));
            w = a-(x-1);
            a = data.annotation.object{1,i}.bndbox.ymax;
            a = str2double(cell2mat(struct2cell(a)));
            h = a-(y-1);
            if strcmp(cell2mat(struct2cell(data.annotation.object{1,i}.name)),ObjectName)
                temp = Car{f};
                temp(k,:) = [x,y,w,h];
                Car{f} = temp;
                k = k+1;
            end
        end
    end
    f = f+1;
end
gTruth = table(imageFilename,Car);
fprintf('The Table is ''gTruth'' in Workspace \n');
fprintf('---Done---\n');
