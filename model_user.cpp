#include "model_user.h"

Model_User::Model_User(QObject *parent)
    : QAbstractListModel(parent)
{
}
Model_User::~Model_User() {
    m_items.clear();
}


///////////////////////////////////////////////////
QHash<int, QByteArray> Model_User::roleNames() const {
    QHash<int, QByteArray> role;

    role[UserIdRole]           = "userid";
    role[UsernameRole]         = "username";
    role[IsActiveRole]         = "isActive";
    role[LoginTimeRole]        = "loginTime";
    role[LogoutTimeRole]       = "logoutTime";
    role[DurationRole]         = "duration";
    role[PasswordRole]         = "password";
    role[UniqueIdRole]         = "uniqueId";

    return role;
}


///////////////////////////////////////////////////
int Model_User::rowCount(const QModelIndex &parent) const
{
    if (parent.isValid())
        return 0;
    return m_items.size();
}


///////////////////////////////////////////////////
QVariant Model_User::data(const QModelIndex &index, int role) const {
    if (!index.isValid() || index.row() < 0 || index.row() >= m_items.size())
        return {};

    static const QHash<int, QByteArray> roles = roleNames();
    auto it = roles.find(role);
    if (it != roles.end()) {
        QVariant value = m_items.at(index.row())->get(it.value());

//        qDebug() << "data() called for row:" << index.row()
//                 << "role:" << it.value()
//                 << "value:" << value;

        return value;
    }

//    qDebug() << "data() called for row:" << index.row()
//             << "role:" << role
//             << "=> not found, returning {}";

    return {};
}

///////////////////////////////////////////////////
bool Model_User::setData(const QModelIndex &index,
                         const QVariant &value,
                         int role)
{
    if (!index.isValid() || index.row() < 0 || index.row() >= m_items.size()) {
//        qDebug() << "setData: Invalid index!" << index << "role:" << role << "value:" << value;
        return false;
    }

    const auto &item = m_items.at(index.row());

    static const QHash<int, QByteArray> roles = roleNames();
    auto it = roles.find(role);
    if (it == roles.end()) {
//        qDebug() << "setData: Role not found!" << role;
        return false;
    }

    QVariant oldValue = item->get(it.value());
//    qDebug() << "setData: row=" << index.row()
//             << "role=" << it.value()
//             << "oldValue=" << oldValue
//             << "newValue=" << value;

    item->set(it.value(), value);

    emit dataChanged(index, index, { role });

//    qDebug() << "setData: Done for row=" << index.row() << "role=" << it.value();
    return true;
}

///////////////////////////////////////////////////
bool Model_User::createItem(const QMap<QString, QVariant> &data)
{
    if (data.isEmpty())
        return false;

    QMap<QString, QVariant> newData = data;

    QString username = newData.value("username").toString();
      if (!isUsernameAvailable(username)) {
          qWarning() << "Username already exists:" << username;
          return false;
      }


    if (!newData.contains("uniqueId")) {
        QString uniqueId;
        bool unique = false;
        do {
            uniqueId = generateUniqueId(10);
            unique = true;

            for (const auto &item : m_items) {
                if (item->get("uniqueId").toString() == uniqueId) {
                    unique = false;
                    break;
                }
            }
        } while (!unique);

        newData["uniqueId"] = uniqueId;
    }

    auto item = QSharedPointer<GenericItem>::create(newData);
    return addItem(item);
}



///////////////////////////////////////////////////
bool Model_User::addItem(const QSharedPointer<GenericItem>& item)
{
    if (!item)
        return false;

    auto spItem = item;                 // QSharedPointer
    QPointer<GenericItem> safeItem = spItem.data();

    connect(spItem.data(), &GenericItem::dataChangedInternally,
            this, [this, safeItem, spItem]() {
        if (!safeItem)
            return;

        int row = m_items.indexOf(spItem);
        if (row >= 0) {
            QModelIndex idx = index(row, 0);
            emit dataChanged(idx, idx);
        }
        UserStorage::save(m_items);
        UserStorage::saveHistory(m_items);
    });



    beginInsertRows(QModelIndex(), m_items.size(), m_items.size());
    m_items.append(item);
    endInsertRows();

    return true;
}

//////////////////////////////////////////////////
int Model_User::loginUser(const QString& username, const QString& password)
{
    int row = -1;

    for (int i = 0; i < m_items.size(); ++i) {
        if (m_items[i]->get("username").toString() == username &&
            m_items[i]->get("password").toString() == password) {
            row = i;
            break;
        }
    }

    if (row == -1) {
        emit loginFailed("Username or password is incorrect.");
        return -1;
    }

    auto idx = index(row, 0);
    setData(idx, true, IsActiveRole);
    setData(idx, QDateTime::currentDateTime().toString(Qt::ISODate), LoginTimeRole);

    emit userDataChanged();
    return row;
}
///////////////////////////////////////////////////
bool Model_User::isValidEmployeeId(const QString& userId)
{
    return m_employeeStorage.isValidEmployeeId(userId);
}

//////////////////////////////////////////////////
bool Model_User::isUsernameAvailable(const QString &username)
{
    for (const auto &item : m_items) {
        if (item->get("username").toString().compare(username, Qt::CaseInsensitive) == 0) {
            return false;
        }
    }
    return true;
}
/////////////////////////////////////////////////////
//bool Model_User::registerUser(const QString& userId,
//                              const QString& username,
//                              const QString& password)
//{
//    if (userId.isEmpty() || username.isEmpty() || password.isEmpty()) {
//        emit loginFailed("All fields are required.");
//        return false;
//    }

//    if (!m_employeeStorage.isValidEmployeeId(userId)) {
//        emit loginFailed("The entered ID does not exist.");
//        return false;
//    }

//    for (const auto& item : qAsConst(m_items)) {
//        if (item->get("username").toString() == username) {
//            emit loginFailed("This username is already taken.");
//            return false;
//        }
//    }

//    QMap<QString, QVariant> data;
//    data["userid"]     = userId;
//    data["username"]   = username;
//    data["password"]   = password;
//    data["isActive"]   = false;
//    data["loginTime"]  = "";
//    data["logoutTime"] = "";
//    data["duration"]   = 0;
//    data["uniqueId"]   = QUuid::createUuid().toString();

//    qDebug() << "Creating new user with data:" << data;


//    if (!createItem(data)) {
//        emit loginFailed("Failed to create user.");
//        return false;
//    }

//    UserStorage::save(m_items);

//    return true;
//}

//////////////////////////////////////////////////
bool Model_User::logoutUser(const QString& username, const QString& userId)
{
    for (int i = 0; i < m_items.size(); ++i) {
        if (m_items[i]->get("userid").toString() == userId &&
                m_items[i]->get("username").toString() == username &&
                m_items[i]->get("isActive").toBool()) {

            auto idx = index(i, 0);
            setData(idx, false, IsActiveRole);
            setData(idx,
                    QDateTime::currentDateTime().toString(Qt::ISODate),
                    LogoutTimeRole);

            UserStorage::save(m_items);
            UserStorage::saveHistory(m_items);

             emit userDataChanged();
            return true;
        }
    }

    return false;
}


//////////////////////////////////////////////////
QMap<QString , QVariant> Model_User::getUser(int row) const{
    if(row<0||row>=m_items.size())
        return {};

    return m_items[row]->getAttributes();
}

///////////////////////////////////////////////////
Qt::ItemFlags Model_User::flags(const QModelIndex &index) const
{
    if (!index.isValid())
        return Qt::NoItemFlags;

    return Qt::ItemIsEditable;
}

///////////////////////////////////////////////////
bool Model_User::removeRows(int row, int count, const QModelIndex &parent)
{
    if (row < 0 || count <= 0 || row + count > m_items.size())
        return false;

    beginRemoveRows(parent, row, row + count - 1);
    m_items.removeAt(row);
    endRemoveRows();

    UserStorage::save(m_items);
    UserStorage::saveHistory(m_items);

    return true;
}
///////////////////////////////////////////////////
bool Model_User::removeUser(int row)
{
    return removeRows(row, 1, QModelIndex());
}

///////////////////////////////////////////////////
bool Model_User::clear()
{
    beginResetModel();
    m_items.clear();
    endResetModel();

    UserStorage::save(m_items);
    UserStorage::saveHistory(m_items);

    return true;
}


///////////////////////////////////////////////////

void Model_User::setUsers(const QVector<QSharedPointer<GenericItem>>& users)
{
    beginResetModel();
    m_items = users;
    endResetModel();
}
///////////////////////////////////////////////////
bool Model_User::updateUser(int row,
                            const QString& username,
                            const QString& password)
{
    if (row < 0 || row >= m_items.size())
        return false;

    QModelIndex idx = index(row, 0);

    setData(idx, username, UsernameRole);
    setData(idx, password, PasswordRole);

    return true;
}
///////////////////////////////////////////////////

QString Model_User::generateUniqueId(int length)
{
    const QString possibleCharacters("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789");
    QString uniqueId;

    for (int i = 0; i < length; ++i) {
        int index = QRandomGenerator::global()->bounded(possibleCharacters.length());
        uniqueId.append(possibleCharacters.at(index));
    }

    return uniqueId;
}
