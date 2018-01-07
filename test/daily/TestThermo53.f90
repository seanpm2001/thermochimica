

    !-------------------------------------------------------------------------------------------------------------
    !
    ! DISCLAIMER
    ! ==========
    !
    ! All of the programming herein is original unless otherwise specified.  Details of contributions to the
    ! programming are given below.
    !
    !
    ! Revisions:
    ! ==========
    !
    !    Date          Programmer        Description of change
    !    ----          ----------        ---------------------
    !    09/19/2015    M.H.A. Piro       Original code
    !
    !
    ! Purpose:
    ! ========
    !
    ! The purpose of this application test is to ensure that the Pu-U-Mo-Zr
    ! quaternary system is correctly computed.  This data-file was kindly
    ! provided by T.M. Besmann, which was converted from the TAF-ID database.
    ! At equilibrium for this particular temperature, pressure and composition,
    ! the BCC phase should be stable.
    !
    !-------------------------------------------------------------------------------------------------------------


program TestThermo53

    USE ModuleThermoIO
    USE ModuleThermo

    implicit none

    integer :: STATUS = 0

    ! Specify units:
    cInputUnitTemperature   = 'K'
    cInputUnitPressure      = 'atm'
    cInputUnitMass          = 'moles'
    cThermoFileName         = '../data/UPMZ_MHP.dat'

    ! Specify values:
    dTemperature            = 302D0
    dPressure               = 1D0
    dElementMass            = 0D0
    dElementMass(94)        = 886D0
    dElementMass(92)        = 300D0
    dElementMass(42)        = 402D0
    dElementMass(40)        = 311D0

    ! Parse the ChemSage data-file:
    call ParseCSDataFile(cThermoFileName)

    ! Call Thermochimica:
    if (INFOThermo == 0) call Thermochimica

    ! Check results:
    if (INFOThermo == 0) then
        ! The fluorite oxide phase should be the only one stable at equilibrium.
        if ((DABS(dMolFraction(69) - 0.600218D0)/0.600218D0 < 1D-3).AND. &
        (DABS(dGibbsEnergySys - (-3.85805D7))/(-3.85805D7) < 1D-3)) then
            ! The test passed:
            print *, 'TestThermo53: PASS'
        else
            ! The test failed.
            print *, 'TestThermo53: FAIL <---'
            STATUS  = 1
        end if
    else
        ! The test failed.
        print *, 'TestThermo53: FAIL <---'
        STATUS  = 1
    end if

    ! Reset Thermochimica:
    call ResetThermo

    call EXIT(STATUS)
end program TestThermo53
