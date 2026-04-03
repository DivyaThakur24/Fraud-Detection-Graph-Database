MATCH (u1:User)-[:MADE]->(t1:Transaction)-[:USED_DEVICE]->(d:Device)<-[:USED_DEVICE]-(t2:Transaction)<-[:MADE]-(u2:User),
      (t1)-[:USED_CARD]->(c:Card)<-[:USED_CARD]-(t2)
WHERE u1.userId < u2.userId
RETURN u1.userId AS userA, u2.userId AS userB, d.deviceId AS sharedDevice, c.cardId AS sharedCard,
       collect(DISTINCT t1.transactionId) + collect(DISTINCT t2.transactionId) AS transactions;

MATCH path = (u1:User)-[*2..4]-(u2:User)
WHERE u1.userId < u2.userId
  AND ALL(node IN nodes(path) WHERE node:User OR node:Transaction OR node:Card OR node:Device OR node:IPAddress)
RETURN u1.userId AS userA, u2.userId AS userB, length(path) AS hopCount,
       [node IN nodes(path) | coalesce(node.userId, node.transactionId, node.cardId, node.deviceId, node.address)] AS pathNodes
LIMIT 10;

MATCH (u:User)-[:MADE]->(:Transaction)-[:USED_CARD]->(c:Card)<-[:USED_CARD]-(:Transaction)<-[:MADE]-(other:User)
WHERE u.userId <> other.userId
WITH c, collect(DISTINCT u.userId) + collect(DISTINCT other.userId) AS rawUsers
UNWIND rawUsers AS userId
WITH c, collect(DISTINCT userId) AS linkedUsers
RETURN c.cardId AS cardId, linkedUsers, size(linkedUsers) AS userCount
ORDER BY userCount DESC, cardId;

MATCH (t1:Transaction)-[:USED_DEVICE]->(d:Device)<-[:USED_DEVICE]-(t2:Transaction),
      (t1)-[:USED_IP]->(ip:IPAddress)<-[:USED_IP]-(t2)
WHERE t1.transactionId < t2.transactionId
RETURN t1.transactionId AS transactionA, t2.transactionId AS transactionB,
       d.deviceId AS sharedDevice, ip.address AS sharedIp
ORDER BY transactionA, transactionB;
