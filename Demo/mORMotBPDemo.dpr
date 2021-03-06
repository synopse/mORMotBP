/// To embed assets to exe add the next three PRE-BUILD events to your Project
//
// ..\Tools\assetslz.exe ..\Assets Assets.synlz
// ..\Tools\resedit.exe $(INPUTNAME).res rcdata ASSETS Assets.synlz
// DEL Assets.synlz

program mORMotBPDemo;

{$APPTYPE CONSOLE}

{$R *.res}

{$I SynDprUses.inc} // Get rid of W1029 annoing warnings

uses
  SynCommons,
  mORMot,
  mORMotHTTPServer,
  BoilerplateAssets in '..\BoilerplateAssets.pas',
  BoilerplateHTTPServer in '..\BoilerplateHTTPServer.pas';

var
  Model: TSQLModel;
  Server: TSQLRestServer;
  HTTPServer: TBoilerplateHTTPServer;

begin
  TAutoFree.One(Model, TSQLModel.Create([]));
  TAutoFree.One(Server, TSQLRestServerFullMemory.Create(Model));
  TAutoFree.One(HTTPServer, TBoilerplateHTTPServer.Create(
    '8092', Server, '+', useHttpApiRegisteringURI, 32, secNone, '/'));

  HTTPServer.LoadFromResource('Assets');

/// Uncomment next two lines delegate static assets transfer to low-level API
//  HTTPServer.Options := HTTPServer.Options + [bpoEnableGZipByMIMETypes];
//  HTTPServer.StaticRoot := 'Temp';

  WriteLn('"mORMot Boilerplate HTTP Server" launched on port 8092 using ' +
    HTTPServer.HttpServer.ClassName + #10#13 +
    #10#13 +
    'You can check http://localhost:8092 for HTTP responces analysis' + #10#13 +
    #10#13 +
    'Press [Enter] to close the server.'#10#13);
  ReadLn;
end.
