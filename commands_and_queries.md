## Аутентификация
| Требование | Actor | Command | Data | Event | Query|
|-|-|-|-|-|-|
|Авторизация в таск-трекере должна выполняться через общий сервис авторизации/Авторизация в дешборде аккаунтинга должна выполняться через общий сервис аутентификации UberPopug Inc.| Account | Login to app | Account auth | Auth.AccountLogined | |
## Таск-трекер
|Требование|Actor|Command|Data|Event|Query|
|-|-|-|-|-|-|
| Новые таски может создавать кто угодно (администратор, начальник, разработчик, менеджер и любая другая роль) | Account | Add task | Task, Account | Tasks.Added | |
| Менеджеры или администраторы должны иметь кнопку «заассайнить задачи» | Account (Admin/Manager) | Assign task | Task, Account | Tasks.Assigned ||
| Каждый сотрудник должен иметь возможность видеть в отдельном месте список заассайненных на него задач | Account || Task, Account || List of assigned tasks |
| Каждый сотрудник должен иметь возможность отметить задачу выполненной | Account | Complete task | Task | Tasks.Completed ||

## Аккаунтинг
| Требование | Actor | Command  | Data | Event | Query |
|-|-|-|-|-|-|
| У обычных попугов доступ к аккаунтингу должен быть, Но только к информации о собственных счетах (аудит лог + текущий баланс) | Account (Employee) || Balance, Balance Audit || Employee balance and audit |
| У админов и бухгалтеров должен быть доступ к общей статистике по деньгами заработанным (количество заработанных топ-менеджментом за сегодня денег + статистика по дням) | Account (Manager, Admin) || Tasks fee, Tasks cost | | Management earned money|
| Цены на задачу определяется единоразово, в момент появления в системе (можно с минимальной задержкой) | Tasks.Added | Calculate task fee and cost | Task | Accounting.TaskCostAndFeeCalculated ||
| Деньги списываются сразу после ассайна на сотрудника | Tasks.Assigned | Withdraw money | Task cost, Balance | Accounting.MoneyWithdrawn ||
| Деньги начисляются после выполнения задачи | Tasks.Completed | Accrue money | Task fee, Balance | Accounting.MoneyAccrued | |
| В конце дня необходимо считать сколько денег сотрудник получил за рабочий день| Accounting.DayEnded | Calculate the employee's earning | Accounts, Balance audit log | Accounting.EmployeeEarningsCalculated ||
| В конце дня отправлять на почту сумму выплаты | Accounting.EmployeeEarningsCalculated | Send employee's earning to email | Account, Employee's earning | Accounting.EmployeeEarningSent ||
| После выплаты баланса (в конце дня) он должен обнуляться |  Accounting.DayEnded | Pay the employee earning | Account, Balance | Accounting.EmployeeEarningPaid ||
| У счёта должен быть аудитлог того, за что были списаны или начислены деньги, с подробным описанием каждой из задач | Accounting.MoneyWithdrawn/Accounting.MoneyAccrued | Add balance audit log | Account, Balance | Accounting.BalanceAuditChanged||
| В аудитлоге всех операций аккаунтинга должно быть отображено, что была выплачена сумма | Accounting.EmployeeEarningPaid | Add balance audit log | Account, Balance | Accounting.BalanceAuditChanged||
