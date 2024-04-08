Select 
  t.rid as TableRID
  ,o.rid
  ,t.field
  ,o.field
from TableName as t
join OtherTable as o on o.rid = t.otherid
where fieldname = 'value'
order by fieldname
