function ExportToExcel (filename, header, data)

xlswrite (filename, header, 'matlab', 'A1');

xlswrite (filename, data, 'matlab', 'A2');


end

