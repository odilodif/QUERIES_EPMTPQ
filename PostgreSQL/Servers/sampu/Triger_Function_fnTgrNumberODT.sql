
ALTER TABLE maint_work_order 
ADD COLUMN number_order_api int8;

/***************************************************/

-- DROP FUNCTION "public"."fnTgrNumberODT"()
CREATE FUNCTION "public"."fnTgrNumberODT"()
RETURNS TRIGGER
LANGUAGE PLPGSQL
AS
$$
DECLARE
vnumber_orderapi INTEGER;
vid INTEGER;
BEGIN
vnumber_orderapi = NEW.number_order_api;
vid = NEW.id;
UPDATE "public"."maint_work_order" SET number_order = vnumber_orderapi WHERE id= vid;
RETURN NEW;
END
$$

/****************************************************/
-- DROP TRIGGER "public.tgrAddNumWordOrderApi" ON maint_work_order
CREATE TRIGGER "public.tgrAddNumWordOrderApi"
AFTER INSERT
ON "public"."maint_work_order"
FOR EACH ROW EXECUTE PROCEDURE "public"."fnTgrNumberODT"();







