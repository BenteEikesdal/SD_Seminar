page 50100 "CSD Seminar Setup"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "CSD Seminar Setup";
    Caption = 'Seminar Setup';
    InsertAllowed = false;
    DeleteAllowed = false;

    
    layout
    {
        area(Content)
        {
            group(Numbering)
            {
                field("seminar Nos."; "Seminar Nos.")
                {
                }
                field("Seminar Registration Nos.";"Seminar Registration Nos.")
                {

                }
                field("Posted Seminar Reg. Nos.";"Posted Seminar Reg. Nos.")
                {

                }

            }
        }
    }
    
    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;
                
                trigger OnAction()
                begin
                    
                end;
            }
        }
    }
    
    var
        myInt: Integer;

        trigger onopenpage();
      
        begin
            if not Get then begin
                Init();
                Insert();
            end;
        end;
}