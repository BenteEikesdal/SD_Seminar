table 50101 "CSD Seminar"
{
    Caption = 'Seminar';

    fields
    {
        field(10; "No."; Code[20])
        {
            Caption = 'No.';
            trigger OnValidate();

            begin
                IF "No." <> xRec."No." THEN BEGIN
                    seminarSetup.GET;
                    NoSeriesMgt.TestManual(seminarSetup."seminar Nos.");
                    "No. Series" := '';
                END;
            end;
        }
        field(20; "Name"; text[50])
        {
            Caption = 'Name';
            trigger onvalidate();
            begin
                IF ("Search Name" = UPPERCASE(xRec.Name)) OR ("Search Name" = '') THEN
                    "Search Name" := Name;
            end;
        }
        field(30; "Seminar Duration"; Decimal)
        {
            Caption = 'Seminar Duration';
            DecimalPlaces = 0 : 1;
        }
        field(40; "Minimum Participants"; integer)
        {
            Caption = 'Minimum Participant';
        }
        field(50; "Maximum Participants"; Integer)
        {
            Caption = 'Maximum Participants';
        }
        field(60; "Search Name"; Code[50])
        {
            Caption = 'Search Name';
        }
        field(70; "Blocked"; Boolean)
        {
            Caption = 'Blocked';
        }
        field(80; "Last Date Modified"; Date)
        {
            Caption = 'Last Date Modified';
            Editable = false;
        }
        field(90; "Comment"; Boolean)
        {
            Caption = 'Comment';
            Editable = false;
            FieldClass = FlowField;
            //CalcFormula = exist("CSD Seminar comment lines" where ("table name"=const("Seminar"),"No."=Field("no.")));
        }
        field(100; "Seminar Price"; Decimal)
        {
            Caption = 'Seminar Price';
            AutoFormatType = 1;
        }
        field(110; "Gen. Prod. Posting Group"; code[10])
        {
            Caption = 'Gen. Prod. Posting Group';
            TableRelation = "Gen. Product Posting Group";
            trigger onvalidate();
            begin
                if (xRec."Gen. Prod. Posting Group" <> "Gen. Prod. Posting Group") then begin
                    if GenProdPostingGroup.ValidateVatProdPostingGroup(GenProdPostingGroup, "Gen. Prod. Posting Group") then
                        Validate("VAT Prod. Posting Group", GenProdPostingGroup."Def. VAT Prod. Posting Group");
                end;
            end;
        }
        field(120; "VAT Prod. Posting Group"; Code[10])
        {
            Caption = 'VAT Prod. Posting Group';
            TableRelation = "VAT Product Posting Group";
        }
        field(130; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            TableRelation = "No. Series";
        }

    }

    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
        key(Key1; "Search Name")
        {

        }
    }

    var
        SeminarSetup: Record "CSD Seminar Setup";
        //CommentLine : record "CSD Seminar Comment Line";
        Seminar: Record "CSD Seminar";
        GenProdPostingGroup: Record "Gen. Product Posting Group";
        NoSeriesMgt: Codeunit NoSeriesManagement;

    trigger OnInsert();
    begin
        IF "No." = '' THEN BEGIN
            seminarSetup.GET;
            seminarSetup.TESTFIELD("seminar Nos.");
            NoSeriesMgt.InitSeries(seminarSetup."seminar Nos.", xRec."No. Series", 0D, "No.", "No. Series");
        END;

    end;

    trigger OnModify();
    begin
        "Last Date Modified" := Today;
    end;

    trigger OnRename();
    begin
        "Last Date Modified" := Today;
    end;

    trigger ondelete()
    begin
        /*         commentline.reset;
                CommentLine.SETRANGE("Table Name", CommentLine."Table Name"::seminar);
                CommentLine.SETRANGE("No.", "No.");
                CommentLine.DELETEALL;
         */
    end;

    procedure AssistEdit(): Boolean;
    begin
        WITH Seminar DO BEGIN
            Seminar := Rec;
            seminarSetup.GET;
            seminarSetup.TESTFIELD("seminar Nos.");
            IF NoSeriesMgt.SelectSeries(seminarSetup."seminar Nos.", xrec."No. Series", "No. Series") THEN BEGIN
                NoSeriesMgt.SetSeries("No.");
                Rec := seminar;
                EXIT(TRUE);
            END;
        END;
    end;

}