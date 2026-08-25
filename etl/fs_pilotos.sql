with todas_corte_data as (
    SELECT 
        * 
        FROM `buchakovga_bronze`.`v2_f1_results`
        
        where 
            date(date) <= date('2024-04-21')
), pilotos_ult_2_anos as (        
    select distinct 
        driverid
    from 
        todas_corte_data
    where 
        year >= ( 
                 select max(year)-2 
                    from 
                todas_corte_data
        )
), tb_results as  (
    select 
        a.* 
    from  todas_corte_data a 

    inner join pilotos_ult_2_anos b 
        on a.driverid = b.driverid

) 
select 
    driverid,
    count(distinct year) as qtde_temporadas,
    count(*) as qtd_corridas,
    sum(case when status = 'Finished' or status like '+%' then 1 else 0 end ) as qtde_finalizadas,
    sum(case when mode = 'Race' and (status = 'Finished' or status like '+%') then 1 else 0 end ) as qtde_finalizadas_race,
    sum(case when mode = 'Sprint' and (status = 'Finished' or status like '+%') then 1 else 0 end ) as qtde_finalizadas_sprint,
    sum(case when mode ='Race' then 1 else 0 end ) as qtde_races,
    sum(case when mode ='Sprint' then 1 else 0 end ) as qtde_sprint,
    sum(case 
            when position = 1 then 1 else 0 end) as qtde_1_lugar  ,              
    sum(case 
            when position = 1 and mode = 'Race' then 1 else 0 end) as qtde_1_lugar_race,
    sum(case 
            when position = 1  and mode = 'Sprint' then 1 else 0 end) as qtde_1_lugar_Sprint,            
    sum(case 
            when position <= 3 then 1 else 0 end) as qtde_podios,
    sum(case 
            when position <= 3 and mode = 'Race' then 1 else 0 end) as qtde_podio_race,
    sum(case 
            when position <= 3  and mode = 'Sprint' then 1 else 0 end) as qtde_podio_Sprint,            

    sum(case 
            when position <= 5 then 1 else 0 end) as qtde_pos5,
    sum(case 
            when position <= 5 and mode = 'Race' then 1 else 0 end) as qtde_pos5_race,
    sum(case 
            when position <= 5  and mode = 'Sprint' then 1 else 0 end) as qtde_pos5_Sprint,            

    sum(case 
            when gridposition <= 5 then 1 else 0 end) as qtde_gridpos5,
    sum(case 
            when gridposition <= 5 and mode = 'Race' then 1 else 0 end) as qtde_gridpos5_race,
    sum(case 
            when gridposition <= 5  and mode = 'Sprint' then 1 else 0 end) as qtde_gridpos5_Sprint,            


    sum(points) as qtde_pontos,
    sum(case when mode = 'Race' then points end ) as qtde_pontos_race,
    sum(case when mode = 'Sprint' then points end ) as qtde_pontos_sprint,
   
    avg(gridposition) as avg_gridposition,
    avg(case when mode = 'Race' then gridposition end ) as avg_gridposition_race,
    avg(case when mode = 'Sprint' then gridposition end ) as avg_gridposition_sprint,
    avg(position) as avg_position,
    avg(case when mode = 'Race' then position end ) as avg_position_race,
    avg(case when mode = 'Sprint' then position end ) as avg_position_sprint  ,  
    sum(case when gridposition = 1 then 1 else 0 end ) as qtde_1_gridposition,
    sum(case when gridposition = 1 and mode = 'Race' then 1 else 0 end ) as qtde_1_gridposition_race,
    sum(case when gridposition = 1 and mode = 'Sprint' then 1 else 0 end ) as qtde_1_gridposition_sprint,
    sum(case when gridposition = 1 and position = 1  then 1 else 0 end ) as qtde_pole_win,

    sum(case when gridposition = 1 and position = 1 and mode = 'Race' then 1 else 0 end ) as qtde_pole_win_race,
    sum(case when gridposition = 1 and position = 1 and mode = 'Sprint' then 1 else 0 end ) as qtde_pole_win_sprint,
    sum(case when points > 0  then 1 else 0 end ) as qtde_com_pontos,
    sum(case when points > 0 and mode = 'Race' then 1 else 0 end ) as qtde_com_pontos_race,
    sum(case when points > 0 and mode = 'Sprint' then 1 else 0 end ) as qtde_com_pontos_sprint,
    sum(case when position < gridposition then 1 else 0 end ) as qtde_corridas_ultrapassou,
    sum(case when position < gridposition and mode = 'Race' then 1 else 0 end ) as qtde_corridas_ultrapassou_race,
    sum(case when position < gridposition and mode = 'Sprint' then 1 else 0 end ) as qtde_corridas_ultrapassou_sprint,
    avg(gridposition - position ) as media_ultrapassagens,
    avg(case when mode = 'Race' then gridposition - position end  ) as media_ultrapassagens_race,
    avg(case when mode = 'Sprint' then gridposition - position end ) as media_ultrapassagens_sprint

    from tb_results
group by driverid

