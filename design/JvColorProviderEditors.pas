{-----------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/MPL-1.1.html

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either expressed or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is: JvColorProviderEditors.pas, released on 2003-09-30.

The Initial Developer of the Original Code is Marcel Bestebroer
Portions created by Marcel Bestebroer are Copyright (C) 2002 - 2003 Marcel
Bestebroer
All Rights Reserved.

Contributor(s):

Last Modified: 2003-09-30

You may retrieve the latest version of this file at the Project JEDI's JVCL home page,
located at http://jvcl.sourceforge.net

Known Issues:
-----------------------------------------------------------------------------}

{$I JVCL.INC}

unit JvColorProviderEditors;

interface

uses
  {$IFDEF COMPILER6_UP}
  DesignIntf, DesignEditors, DesignMenus, VCLEditors,
  {$ELSE}
  DsgnIntf,
  {$ENDIF}
  Classes,
  JvColorProvider, JvDataProviderEditors;

type
  TJvColorProviderMappingProperty = class(TJvDataConsumerExtPropertyEditor)
  public
    function GetAttributes: TPropertyAttributes; override;
    function GetValue: string; override;
    procedure SetValue(const Value: string); override;
    procedure GetValues(Proc: TGetStrProc); override;
  end;

implementation

uses
  SysUtils, TypInfo,
  JvDataProvider;

//===TJvColorProviderMappingProperty================================================================

function TJvColorProviderMappingProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paValueList, paSortList, paRevertable];
end;

function TJvColorProviderMappingProperty.GetValue: string;
var
  I: Integer;
begin
  I := GetOrdValue;
  if I = -1 then
    Result := '(none)'
  else
    Result := (GetConsumerImpl.ProviderIntf as IJvColorProvider).Get_Mapping(I).Name;
end;

procedure TJvColorProviderMappingProperty.SetValue(const Value: string);
var
  I: Integer;
begin
  if AnsiSameStr(Value, '(none)') or (Value = '') then
    SetOrdValue(-1)
  else
  begin
    with GetConsumerImpl.ProviderIntf as IJvColorProvider do
    begin
      I := IndexOfMappingName(Value);
      if I < 0 then
        raise EPropertyError.Create('Mapping does not exist for this color provider.');
      SetOrdValue(I);
    end;
  end;
end;

procedure TJvColorProviderMappingProperty.GetValues(Proc: TGetStrProc);
var
  I: Integer;
begin
  with GetConsumerImpl.ProviderIntf as IJvColorProvider do
  begin
    for I := 0 to Get_MappingCount - 1 do
      Proc(Get_Mapping(I).Name);
  end;
end;

end.
