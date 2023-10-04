codeunit 50100 PTEGLNTest
{
    Subtype = Test;

    trigger OnRun();
    begin
        IsInitialized := false;
    end;

    local procedure Initialize();
    begin
        LibraryTestInitialize.OnTestInitialize(Codeunit::PTEGLNTest);
        ClearLastError();
        LibraryVariableStorage.Clear();
        LibrarySetupStorage.Restore();
        if IsInitialized then
            exit;

        LibraryTestInitialize.OnBeforeTestSuiteInitialize(Codeunit::PTEGLNTest);

        LibraryRandom.Init();

        // CUSTOMIZATION: Prepare setup tables etc. that are used for all test functions


        IsInitialized := true;
        Commit();

        // CUSTOMIZATION: Add all setup tables that are changed by tests to the SetupStorage, so they can be restored for each test function that calls Initialize.
        // This is done InMemory, so it could be run after the COMMIT above
        //   LibrarySetupStorage.Save(DATABASE::"[SETUP TABLE ID]");

        LibraryTestInitialize.OnAfterTestSuiteInitialize(Codeunit::PTEGLNTest);
    end;

    [Test]
    procedure InsertGlnPositiveTest()
    var
        CompanyInformation: Record "Company Information";
    begin
        Initialize();
        // [GIVEN] Company Information Record
        CompanyInformation.Get();
        // [WHEN] Entering a valid GLN
        CompanyInformation.Validate(GLN, '1234567890128');
        // [THEN] No error is returned
    end;

    [Test]
    procedure InsertGlnNegativeTest()
    var
        CompanyInformation: Record "Company Information";
    begin
        Initialize();
        // [GIVEN] Company Information Record
        CompanyInformation.Get();
        // [WHEN] Entering a unvalid GLN
        asserterror CompanyInformation.Validate(GLN, '1234567890123');
        // [THEN] Return the expected error
        Assert.ExpectedErrorCode('Dialog');
        Assert.ExpectedError('The GLN is not valid.');
    end;

    var
        Assert: Codeunit Assert;
        LibraryRandom: Codeunit "Library - Random";
        LibrarySetupStorage: Codeunit "Library - Setup Storage";
        LibraryTestInitialize: Codeunit "Library - Test Initialize";
        LibraryVariableStorage: Codeunit "Library - Variable Storage";
        IsInitialized: Boolean;
}
