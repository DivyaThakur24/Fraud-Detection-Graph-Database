MATCH (n) DETACH DELETE n;

MERGE (u1:User {userId: 'U100', name: 'Alice'})
MERGE (u2:User {userId: 'U200', name: 'Bob'})
MERGE (u3:User {userId: 'U300', name: 'Cara'})
MERGE (u4:User {userId: 'U400', name: 'Dan'})
MERGE (u5:User {userId: 'U500', name: 'Eva'})
MERGE (u6:User {userId: 'U600', name: 'Finn'});

MERGE (c1:Card {cardId: 'CARD-1111'})
MERGE (c2:Card {cardId: 'CARD-2222'})
MERGE (c3:Card {cardId: 'CARD-3333'});

MERGE (d1:Device {deviceId: 'DEV-01'})
MERGE (d2:Device {deviceId: 'DEV-02'})
MERGE (d3:Device {deviceId: 'DEV-03'});

MERGE (ip1:IPAddress {address: '10.0.0.10'})
MERGE (ip2:IPAddress {address: '10.0.0.11'})
MERGE (ip3:IPAddress {address: '10.0.0.12'});

MERGE (m1:Merchant {merchantId: 'M100', name: 'ElectroMart'})
MERGE (m2:Merchant {merchantId: 'M200', name: 'QuickPay'})
MERGE (m3:Merchant {merchantId: 'M300', name: 'TravelHub'});

MATCH (u1:User {userId: 'U100'}), (u2:User {userId: 'U200'}), (u3:User {userId: 'U300'}),
      (u4:User {userId: 'U400'}), (u5:User {userId: 'U500'}),
      (c1:Card {cardId: 'CARD-1111'}), (c2:Card {cardId: 'CARD-2222'}), (c3:Card {cardId: 'CARD-3333'}),
      (d1:Device {deviceId: 'DEV-01'}), (d2:Device {deviceId: 'DEV-02'}), (d3:Device {deviceId: 'DEV-03'})
MERGE (u1)-[:OWNS_CARD]->(c1)
MERGE (u2)-[:OWNS_CARD]->(c2)
MERGE (u3)-[:OWNS_CARD]->(c1)
MERGE (u4)-[:OWNS_CARD]->(c3)
MERGE (u5)-[:OWNS_CARD]->(c2)
MERGE (u1)-[:REGISTERED_DEVICE]->(d1)
MERGE (u2)-[:REGISTERED_DEVICE]->(d2)
MERGE (u3)-[:REGISTERED_DEVICE]->(d1)
MERGE (u4)-[:REGISTERED_DEVICE]->(d3)
MERGE (u5)-[:REGISTERED_DEVICE]->(d2);

MERGE (t1:Transaction {transactionId: 'TX-001', amount: 450, status: 'approved'})
MERGE (t2:Transaction {transactionId: 'TX-002', amount: 920, status: 'approved'})
MERGE (t3:Transaction {transactionId: 'TX-003', amount: 1200, status: 'flagged'})
MERGE (t4:Transaction {transactionId: 'TX-004', amount: 300, status: 'approved'})
MERGE (t5:Transaction {transactionId: 'TX-005', amount: 1600, status: 'flagged'})
MERGE (t6:Transaction {transactionId: 'TX-006', amount: 700, status: 'approved'});

MATCH (u1:User {userId: 'U100'}), (u2:User {userId: 'U200'}), (u3:User {userId: 'U300'}),
      (u4:User {userId: 'U400'}), (u5:User {userId: 'U500'}), (u6:User {userId: 'U600'}),
      (t1:Transaction {transactionId: 'TX-001'}), (t2:Transaction {transactionId: 'TX-002'}),
      (t3:Transaction {transactionId: 'TX-003'}), (t4:Transaction {transactionId: 'TX-004'}),
      (t5:Transaction {transactionId: 'TX-005'}), (t6:Transaction {transactionId: 'TX-006'})
MERGE (u1)-[:MADE]->(t1)
MERGE (u2)-[:MADE]->(t2)
MERGE (u3)-[:MADE]->(t3)
MERGE (u4)-[:MADE]->(t4)
MERGE (u5)-[:MADE]->(t5)
MERGE (u6)-[:MADE]->(t6);

MATCH (t1:Transaction {transactionId: 'TX-001'}), (t2:Transaction {transactionId: 'TX-002'}),
      (t3:Transaction {transactionId: 'TX-003'}), (t4:Transaction {transactionId: 'TX-004'}),
      (t5:Transaction {transactionId: 'TX-005'}), (t6:Transaction {transactionId: 'TX-006'}),
      (c1:Card {cardId: 'CARD-1111'}), (c2:Card {cardId: 'CARD-2222'}), (c3:Card {cardId: 'CARD-3333'})
MERGE (t1)-[:USED_CARD]->(c1)
MERGE (t2)-[:USED_CARD]->(c2)
MERGE (t3)-[:USED_CARD]->(c1)
MERGE (t4)-[:USED_CARD]->(c3)
MERGE (t5)-[:USED_CARD]->(c2)
MERGE (t6)-[:USED_CARD]->(c2);

MATCH (t1:Transaction {transactionId: 'TX-001'}), (t2:Transaction {transactionId: 'TX-002'}),
      (t3:Transaction {transactionId: 'TX-003'}), (t4:Transaction {transactionId: 'TX-004'}),
      (t5:Transaction {transactionId: 'TX-005'}), (t6:Transaction {transactionId: 'TX-006'}),
      (d1:Device {deviceId: 'DEV-01'}), (d2:Device {deviceId: 'DEV-02'}), (d3:Device {deviceId: 'DEV-03'})
MERGE (t1)-[:USED_DEVICE]->(d1)
MERGE (t2)-[:USED_DEVICE]->(d2)
MERGE (t3)-[:USED_DEVICE]->(d1)
MERGE (t4)-[:USED_DEVICE]->(d3)
MERGE (t5)-[:USED_DEVICE]->(d2)
MERGE (t6)-[:USED_DEVICE]->(d2);

MATCH (t1:Transaction {transactionId: 'TX-001'}), (t2:Transaction {transactionId: 'TX-002'}),
      (t3:Transaction {transactionId: 'TX-003'}), (t4:Transaction {transactionId: 'TX-004'}),
      (t5:Transaction {transactionId: 'TX-005'}), (t6:Transaction {transactionId: 'TX-006'}),
      (ip1:IPAddress {address: '10.0.0.10'}), (ip2:IPAddress {address: '10.0.0.11'}), (ip3:IPAddress {address: '10.0.0.12'})
MERGE (t1)-[:USED_IP]->(ip1)
MERGE (t2)-[:USED_IP]->(ip2)
MERGE (t3)-[:USED_IP]->(ip1)
MERGE (t4)-[:USED_IP]->(ip3)
MERGE (t5)-[:USED_IP]->(ip2)
MERGE (t6)-[:USED_IP]->(ip2);

MATCH (t1:Transaction {transactionId: 'TX-001'}), (t2:Transaction {transactionId: 'TX-002'}),
      (t3:Transaction {transactionId: 'TX-003'}), (t4:Transaction {transactionId: 'TX-004'}),
      (t5:Transaction {transactionId: 'TX-005'}), (t6:Transaction {transactionId: 'TX-006'}),
      (m1:Merchant {merchantId: 'M100'}), (m2:Merchant {merchantId: 'M200'}), (m3:Merchant {merchantId: 'M300'})
MERGE (t1)-[:AT_MERCHANT]->(m1)
MERGE (t2)-[:AT_MERCHANT]->(m2)
MERGE (t3)-[:AT_MERCHANT]->(m1)
MERGE (t4)-[:AT_MERCHANT]->(m3)
MERGE (t5)-[:AT_MERCHANT]->(m2)
MERGE (t6)-[:AT_MERCHANT]->(m2);
