function r2cFile(Var,VarName,Unit,latitude,longitude,time)

format_out =('"yyyy/mm/dd HH:MM:SS.000"');
dtime_str  = datestr(time, format_out);

% création de la première grille 7x5 et le texte 
FileNme = sprintf('%s.r2c',VarName);
fVar = fopen(FileNme, 'w');          % ouvrir le fichier r2c
fmt = [repmat(' %.2f ', 1, 5) '\n']; % format des données
xOrigin = longitude(1);
yOrigin = latitude(end);



fprintf(fVar, '%s\n','########################################',':FileType r2c  ASCII  EnSim 1.0','#','# DataType               2D Rect Cell','#');
fprintf(fVar, '%s\n',':Application             FORTRAN',':Version                 1.0.0',':WrittenBy               MSC/HAL/GIWS',':CreationDate            01/25/  13 19:12:44');
fprintf(fVar, '%s\n','#','#---------------------------------------','#',':Name                    TT','#',':Projection              LATLONG',':Ellipsoid               WGS84');
fprintf(fVar, '%s\n','#',sprintf(':xOrigin                  %s',xOrigin),sprintf(':yOrigin                   %s',yOrigin),'#',':SourceFile              XXXX/           X');
fprintf(fVar, '%s\n', '#',sprintf(':AttributeName           %s',VarName),sprintf(':AttributeUnit           %s',Unit),'#');
fprintf(fVar, '%s\n',':xCount                   5',':yCount                   7',':xDelta                   0.205960',':yDelta                   0.134740','#','#');
fprintf(fVar, '%s\n', ':endHeader');


for j = 1: size(Var,3) % numéro total du pas de temps
    fprintf(fVar, '%s %8d %7d %s\n', ':Frame',j ,j, dtime_str(j,:)); % ligne des dates
    Variable = squeeze(Var(:,:,j));
    [Xq,Yq] = meshgrid(1:5,1:7); % resize 5x7
    Variable = interp2(Variable, Xq, Yq);% interpolation of data in the resize 5x7
    fprintf(fVar, fmt, Variable.');
    fprintf(fVar, '%s\n', ':EndFrame');
end
    fclose(fVar);% fermer le fichier r2c
end
    
