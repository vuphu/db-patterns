DROP TABLE IF EXISTS nodes;

CREATE TABLE nodes
(
    id        SERIAL,
    type      CHARACTER VARYING(10)  NOT NULL,
    name      CHARACTER VARYING(255) NOT NULL,
    parent_id INTEGER                NULL,

    PRIMARY KEY (id)
);

ALTER TABLE nodes
    ADD CONSTRAINT CK_nodes_type CHECK ( type IN ('folder', 'file') );

ALTER TABLE nodes
    ADD CONSTRAINT FK_nodes_nodes
        FOREIGN KEY (parent_id) REFERENCES nodes (id);

INSERT INTO nodes(id, type, name, parent_id)
VALUES (1, 'folder', 'root', NULL),
       (2, 'folder', 'documents', 1),
       (3, 'folder', 'desktop', 1),
       (4, 'folder', 'downloads', 1),
       (5, 'folder', 'pictures', 1),
       (6, 'folder', 'works', 2),
       (7, 'folder', 'personal', 2),
       (8, 'file', 'guidelines.docx', 6),
       (9, 'file', 'resume.docx', 7);


WITH RECURSIVE tree AS (
    SELECT *
    FROM nodes
    WHERE id = 8
        UNION ALL
    SELECT nodes.*
    FROM nodes
    INNER JOIN tree ON nodes.id = tree.parent_id
)
SELECT *
FROM tree;

WITH RECURSIVE tree AS (
    SELECT *
    FROM nodes
    WHERE id = 2
        UNION ALL
    SELECT nodes.*
    FROM nodes
    INNER JOIN tree ON nodes.parent_id = tree.id
)
SELECT *
FROM tree;

