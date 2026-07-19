-- comment line: select, from, where, order by should be treated as SQL keywords
with filtered as (
    /* block comment with nested select/from/where keywords */
    select
        t.rid as TableRID
        ,o.rid as OtherRID
        ,t.field as TableField
        ,o.field as OtherField
        ,case
            when t.field = 'value' then 'match'
            else 'no-match'
          end as MatchStatus
    from TableName as t
    join OtherTable as o
        on o.rid = t.otherid
    where t.fieldname = 'value'
      and o.field is not null
      and exists (
            select
                1
            from ThirdTable as tt
            where tt.parentid = t.rid
      )
)

select
    f.TableRID
    ,f.OtherRID
    ,f.TableField
    ,f.OtherField
    ,f.MatchStatus
from filtered as f
left join ThirdTable as tt
    on tt.parentid = f.TableRID
where f.TableField in ('value', 'other')
  and f.MatchStatus = 'match'
group by
    f.TableRID
    ,f.OtherRID
    ,f.TableField
    ,f.OtherField
    ,f.MatchStatus
having count(*) > 0
order by
    f.TableRID asc
    ,f.TableField desc
