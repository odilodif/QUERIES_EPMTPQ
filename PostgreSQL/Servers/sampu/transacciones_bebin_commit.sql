SELECT * FROM cuentas ORDER BY numero;

/* Se necesitan dos acciones:
1. Disminuir $20000 de la cuenta B
2. Aumentar $20000 a la cuenta A

*/

BEGIN;

UPDATE cuentas SET saldo = saldo - 20000
WHERE numero = 'B';

UPDATE cuentas SET saldo = saldo + 20000
WHERE numero = 'A';

COMMIT;