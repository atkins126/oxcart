{
   makecodenames, creates a list of data type code names
   Copyright (c) 2009. Dejan Boras

   DESCRIPTION:
      This program will create a data type codee name list from the
   stdDataTypeCodes.inc file. It is required to be done whenever
   stdDataTypeCodes.inc is changed to make sure that name list
   matches the codes.
}

{$MODE OBJFPC}{$H+}{$I-}
PROGRAM makecodenames;

USES
   uStd, StringUtils, ConsoleUtils, uSimpleParser;

TYPE
   TCodeName = string;

   TCode = record
      Name: TCodeName;
   end;

VAR
   cnames: specialize TSimpleList<TCode>;
   parseData: TParseData;

function doReadFile(var p: TParseData): boolean;
var
   item,
   name: string;

   value, code: longint;
   cName: TCode;

begin
   Result := true;

   {check the string}
   if(pos('=', p.CurrentLine) <> 0) and (pos(';', p.CurrentLine) <> 0) then begin
      name := '';
      cName.Name := '';

      {get the code name}
      item := CopyToDel(p.CurrentLine, '=');
      StripWhiteSpace(item);

      {check the code name}
      {NOTE: Data type constant have a 'dtc' prefix and have at least
      1 character(therefore the minimum size is 4 characters).}
      if(pos('dtc', item) = 0) or (Length(item) < 4) then
            exit;

      delete(item, 1, 3); {get rid of the prefix}
      name := item;

      {delete the equal symbol}
      delete(p.CurrentLine, 1, 1);

      {get the code value}
      item := CopyToDel(p.CurrentLine, ';');
      StripWhitespace(p.CurrentLine);

      val(item, value, code);

      {add the code to the list}
      if(code = 0) and (value < 255) and (value >= 0) then begin
         if(cname.Name = '') then
            cname.Name := name;

         writeln('Found: ', cname.Name);
         cnames.Add(cname);
      end;
   end;
end;

function doWriteFile(var p: TParseData): boolean;
var
   i: longint;
   s,
   ls: string;

begin
   Result := true;

   {write a header}
   p.f.Writeln('{');
   p.f.Writeln('   File generated by makecodenames program from stdDataTypeCodes.inc.');

   p.f.Writeln('}');
   p.f.Writeln('');

   {write constants}
   p.f.Writeln('   dtcDataTypeCodeNames = ' + sf(cnames.n) + ';');
   p.f.Writeln('');

   {write code strings}
   p.f.Writeln('   {data type code name strings}');
   for i := 0 to cnames.n - 1 do begin
      if(Length(cnames[i].Name) > 0) then begin
         s := 'dts' + cnames[i].Name;

         ls := '   ' + s + ': string[' + sf(Length(cnames[i].Name)) + '] = ''' +
            cnames[i].Name + ''';';

         p.f.Write(ls);
         s := sf(i);
         AddLeadingPadding(s, '0', 3);
         p.f.Writeln('{' + s + '}');
      end;
   end;

   p.f.Writeln('');

   {write the code name array, a list of pointers to strings}
   p.f.Writeln('   {data type code name array}');
   p.f.Writeln('   cDataTypeCodeNames: array[0..dtcDataTypeCodeNames-1] of pshortstring = (');
   for i := 0 to cnames.n - 1 do begin
      s := sf(i);
      AddLeadingPadding(s, '0', 3);
      p.f.Write('      {' + s + '}');

      if(Length(cnames[i].Name) > 0) then begin
         s := '@dts' + cnames[i].Name;
         p.f.Write(s);
      end else
         p.f.Write('nil');

      if(i < cnames.n - 1) then
         p.f.Write(',');

      p.f.Writeln('');
   end;

   p.f.Writeln('   );');
end;

BEGIN
   writeln('makecodenames v1.0');
   writeln('This program is open source under GNU GPL v3.');
   writeln();

   {initialize}
   cnames.Initialize(cnames);
   TParseData.Init(parseData);

   parseData.Read('stdDataTypeCodes.inc', TParseExtMethod(@doReadFile));
   if(ioE <> 0) then
      exit;

   {process data}
   if(cnames.n = 0) then begin
      console.e('There are no data type codes.');
      exit;
   end;

   TParseData.Init(parseData);

   {write the file}
   parseData.Write('stdDataTypeCodeNames.inc', TParseExtMethod(@doWriteFile));
   if(ioE <> 0) then
      exit;

   Writeln('Operation completed successfully.');
END.
