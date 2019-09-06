import FluentSQLite
import Vapor
import Authentication

public func configure(_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws {
	
	let router = EngineRouter.default()
	try routes(router)
	services.register(router, as: Router.self)
	
	let directoryConfig = DirectoryConfig.detect()
	services.register(directoryConfig)
	
	try services.register(FluentSQLiteProvider())
	
	try services.register(AuthenticationProvider())
	
	var databaseConfig = DatabasesConfig()
	let db = try SQLiteDatabase(storage: .file(path: "\(directoryConfig.workDir)auth.db"))
	databaseConfig.add(database: db, as: .sqlite)
	services.register(databaseConfig)
	
	var migrationConfig = MigrationConfig()
	migrationConfig.add(model: User.self, database: .sqlite)
	migrationConfig.add(model: Todo.self, database: .sqlite)
	services.register(migrationConfig)
}
