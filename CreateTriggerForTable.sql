-- For one table:
CREATE TRIGGER test AFTER INSERT OR UPDATE OR DELETE ON t_trig_table 

        FOR EACH ROW EXECUTE PROCEDURE change_trigger();

-- For multiple tables:
CREATE TRIGGER testtrigger 
AFTER INSERT OR UPDATE OR DELETE 
ON 'table1 || table2 || table3 || ... '
        FOR EACH ROW EXECUTE PROCEDURE change_trigger();
      
