BEGIN

 

FOR PRODUTO IN (

 

    (SELECT

    proc.idiproc,

    cab.nunota,

    lpa.codprodpa,

    tpp.codprodtar,

    tpp.qtd,

    ite.qtdneg,

    ( tpp.qtd * ite.qtdneg ) AS qtdreal,

    (

        SELECT

            i.vlrunit

        FROM

            tgfite i

        WHERE

            i.nunota = ite.nunota

            AND i.codprod = tpp.codprodtar

    ) AS vlrtar,

    (

        SELECT

            i.vlrunit

        FROM

            tgfite i

        WHERE

            i.nunota = ite.nunota

            AND i.codprod = tpp.codprodtar

    ) * ( tpp.qtd * ite.qtdneg ) AS vlrReal

FROM

    tprprc     prc

    INNER JOIN tprlpa     lpa ON lpa.idproc = prc.idproc

    INNER JOIN tprtpp     tpp ON tpp.idproc = prc.idproc

                             AND lpa.codprodpa = tpp.codprodpa

    INNER JOIN tpriproc   proc ON proc.idproc = prc.idproc

    INNER JOIN tgfcab     cab ON cab.idiproc = proc.idiproc

    INNER JOIN tgfite     ite ON ite.nunota = cab.nunota

                             AND ite.codprod = lpa.codprodpa

                             AND ite.usoprod = 'V'

WHERE

    cab.dtneg BETWEEN '26/02/2021' and '31/03/2021'
    AND cab.CODEMP = 2)

) LOOP

   

    update tgfite set qtdneg = PRODUTO.qtdreal, vlrtot = PRODUTO.vlrReal where nunota = PRODUTO.nunota and codprod = PRODUTO.codprodtar;

   

    

    END LOOP;

   

    END;
