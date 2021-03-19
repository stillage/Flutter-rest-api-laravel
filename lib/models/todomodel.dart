class Todo {
  int id;
  String title;
  int completed;
  String create_by;
  String dateline;
  int priority;
  String to_user;
  String created_at;

  Todo({
    this.id,
    this.title,
    this.completed,
    this.create_by,
    this.dateline,
    this.priority,
    this.to_user,
    this.created_at,
  });

  factory Todo.fromJson(Map<String, dynamic> json) => Todo(
        id: json['id'],
        title: json['title'],
        completed: json['completed'],
        create_by: json['create_by'],
        dateline: json['dateline'],
        priority: json['priority'],
        to_user: json['to_user'],
        created_at: json['created_at'],
      );
}
