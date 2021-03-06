{
   xkeycodecreate, creates an X Input keysym remapping list from an include file
   Copyright (C) 2009. Dejan Boras
}

{$MODE OBJFPC}{$H+}{$I-}
PROGRAM xkeycoderemap;

USES
   StringUtils, appKeyCodeNames, uSimpleParser;

CONST
   XK_MISC_START     = $ff08;
   XK_MISC_END       = $ffff;
   XK_LATIN_START    = $fe00;
   XK_LATIN_END      = $feff;

TYPE
   TRemap = record
      keysymvalue: longword;
      KeyCode: longword;
   end;

   TRemaps = array[0..255] of TRemap;

VAR
   miscRemaps: TRemaps;
   latinRemaps: TRemaps;

{read the file line by line}
function doReadFile(var s: string): boolean;
var
   code: longint;
   ls, item: string;
   {skeysym, }kcName: string[63];
   keysymvalue, map: longword;
   keycode: longint;

begin
   doReadFile := true;

   {now we will try to process the strings}
   ls := s;

   {extract the first item(keysym)}
   item := dCopy2Del(ls);
   {if we got a keysym remap}
   if(pos('XK', item) > 0)
   and (pos('=', ls) > 0) and (pos('(', ls) > 0)
   and (pos(')', ls) > 0) and (pos(',', ls) > 0) then begin
      {get the keysym name}
      //skeysym := item;
      {remove everything until the ( bracket}
      dCopy2Del(ls, '(');
      {get the keysym value, if not valid continue to next line}
      item := dCopy2Del(ls, ',');
      dStripWhiteSpace(item);
      val(item, keysymvalue, code);
      if(code <> 0) then exit;
      {remove the comma}
      delete(ls, 1, 1);
      {get the keycode name}
      item := dCopy2Del(ls, ')');
      dStripWhiteSpace(item);
      {if there is a keycode name (keycode names have at least 3 characters)}
      if(Length(item) > 2) then begin
         kcName := item;

         {try to find the keycode}
         keycode := appkFindKeyCodeByName(kcName);
         if(keycode <> 0) then begin
            {put the keycode in the misc remap list}
            if(keysymvalue >= XK_MISC_START) and (keysymvalue <= XK_MISC_END) then begin
               map := keysymvalue - $FF00;
               miscRemaps[map].KeyCode := KeyCode;
               miscRemaps[map].keysymvalue := keysymvalue;
            end else if(keysymvalue >= XK_LATIN_START) and (keysymvalue <= XK_LATIN_END) then begin
               map := keysymvalue - $FE00;
               latinRemaps[map].Keycode := KeyCode;
               latinRemaps[map].keysymvalue := keysymvalue;
            end;
         end;
      end;
   end;
end;

{write the file line by line}
function doWriteFile(var f: text): boolean;

procedure WriteRemaps(var r: TRemaps);
var
   i: longint;
   s: string;
   kcName: string;

begin
   for i := 0 to 255 do begin
      s := sf((i);
      dStringAddPaddingLeading(s, '0', 3);
      write(f, '{'+s+'}');

      kcName := '';
      if(r[i].KeyCode > 0) then 
         kcName := appkGetKeyCodepName(r[i].KeyCode);

      if(kcName = nil) then
         write(f, '0')
      else 
         write(f, kcName^);

      if(i < 255) then 
         writeln(f, ',');
   end;
   writeln(f, ');');
end;

begin
   doWriteFile := true;

   {write the header}
   writeln(f, '{');
   writeln(f, '   File generated by xkeycoderemap from xkesysym.inc.');
   writeOnDate(f);
   writeln(f, '}');

   {write the miscRemap array}
   writeln(f, ' xkcMiscRemaps: array[0..255] of uint8 = (');
   WriteRemaps(miscRemaps);
   writeln(f, '');

   {write the latinRemap array}
   writeln(f, ' xkcLatinRemaps: array[0..255] of uint8 = (');
   WriteRemaps(latinRemaps);
end;

{PROGRAM START}
BEGIN
   writeln('xkeycoderemap version 1.0');
   writeln('Copyright (c) 2009. Dejan Boras');
   writeln('This program is open source under the GNU General Public License v3.');

   ReadFile('xkeysyms.inc', @doReadFile);
   if(ioE <> 0) then begin 
      writeln('I/O Error: ', ioE); 
      exit; 
   end;

   WriteFile('xkeyremapcodes.inc', @doWriteFile);
   if(ioE <> 0) then begin 
      writeln('I/O Error: ', ioE); 
      exit; 
   end;
END.
