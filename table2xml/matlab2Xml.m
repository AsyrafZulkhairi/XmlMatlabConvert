%This script convert label data from gTruth table exported by Matlab Image Labeler to xml files with PascalVOC format. 
%Require struct2xml.m in current path.
%by Asyraf Zulkhairi

%The table 'gTruth' will be process
clear data
[rows,cols] = size(gTruth.Car);
labelName = 'car';% Depends on what label you want
fprintf('Using label name ''%s''\n',labelName);
fprintf('Press any key to continue\n');
pause();
for row = 1:rows
    data.annotation.folder.Text='xml2table'; % Depends on image source
    [filepath,name,ext] = fileparts(gTruth.imageFilename{row});
    %filepath = 'D:\Research\XmlMatlabConvert\xml2table\label';
    data.annotation.filename.Text=[name ext];
    data.annotation.path.Text=gTruth.imageFilename{row};
    data.annotation.source.database.Text='Unknown';
    if isfile([filepath '\' name ext])==0
        fprintf('%s does not exist\n',[filepath '\' name ext]);
        fprintf('If using different path, edit path in this script line 14\n');
    end
    [hei, wid, numberOfColorChannels] = size(imread([filepath '\' name ext]));
    data.annotation.size.width.Text=wid;
    data.annotation.size.height.Text=hei;
    data.annotation.size.depth.Text=numberOfColorChannels;
    data.annotation.segmented.Text='0';
    [a,b] = size(gTruth.Car{row});
    
    % If there is no bounding box, xml file not created
    if a == 0
        clear data
        fprintf('%d of %d\n',row,rows);
        continue;
    end
    for i = 1:a
        data.annotation.object{1,i}.name.Text=labelName;
        data.annotation.object{1,i}.pose.Text='Unspecified';
        data.annotation.object{1,i}.truncated.Text='0';
        data.annotation.object{1,i}.difficult.Text='0';
        data.annotation.object{1,i}.bndbox.xmin.Text=gTruth.Car{row}(i,1);
        data.annotation.object{1,i}.bndbox.ymin.Text=gTruth.Car{row}(i,2);
        data.annotation.object{1,i}.bndbox.xmax.Text=gTruth.Car{row}(i,1)+gTruth.Car{row}(i,3)-1;
        data.annotation.object{1,i}.bndbox.ymax.Text=gTruth.Car{row}(i,2)+gTruth.Car{row}(i,4)-1;
    end
    
    % Create Xml file
    struct2xml(data, ['output\' name '.xml']);
    
    % Copy image file to the same directory
    copyfile([filepath '\' name ext], 'output\')
    
    clear data
    fprintf('%d of %d\n',row,rows);
end
fprintf('---Done---\n');